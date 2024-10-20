class BookImporter < BaseImporter
  def initialize(vx, keys, ks, import_date)
    @logger = LoggerUtils.logger()

    super(vx, keys, ks)
    @detector = BookDetectorImporter.new()
    @name = "book"
    @ar_klass = Booklist
    @import_date = import_date

    @ignore_fields = %w[isbn series comments rating identifiers]

    @fix_data = ConfigUtils.get_configx_for_book_ymal( ConfigUtils.book_yaml_pn ).book
  end

  def select_valid_data_x(x, data_array)
    keys = x.keys
    keys.each do |k|
      if x[k].instance_of?(Hash)
        select_valid_data_y(x[k], data_array)
      end
    end
  end

  def select_valid_data_y(x, data_array)
    if x.instance_of?(Hash)
      select_valid_data(x, "purchase_date", "asin", Booklist, data_array)
    end
  end

  def fix_shape(x , key, value_for_key, sub_key)
    objx =  @fix_data[key][value_for_key][sub_key]

    # name = "アマゾン(Kindle)"
    value = x[key]
    return if value != value_for_key
    value_for_sub_key = x[sub_key]
    new_value_for_sub_key = objx.select{|k,v| value_for_sub_key == k }[value_for_sub_key]
    x[key] = Shape.find_by(name: new_value_for_sub_key).id
  end

  def xf_supplement(target, x, base_number = 0)
    if x["totalid"]
      x["totalID"] = x["totalid"]
      x.delete("totalid")
    end
    if x["totalID"]
      x["totalID"] = x["xid"].to_i + base_number
      @detector.find_duplicated_field_value(target, "totalID", x)
    end

    # set_assoc(x, Category, "read_status", "readstatus")
    if x["read_status"] == 0
      x["read_status"] = Readstatus.find_by(name: "").id
    end
    set_assoc(x, Readstatus, "read_status", "readstatus")
    set_assoc(x, Bookstore, "bookstore")

    fix_shape(x, "shape", 3, "bookstore")
    x["shape_id"] = x["shape"]
    if x["shape_id"].nil?
      x["shape_id"] = Shape.find_by(name: "").id
    elsif x["shape_id"].instance_of?(String) && x["shape_id"].strip.empty?
      x["shape_id"] = Shape.find_by(name: "").id
    end

    x["category_id"] = x["category"]
    if x["category_id"].nil?
      x["category_id"] = Category.find_by(name: "").id
    elsif x["category_id"].instance_of?(String) 
      if x["category_id"].strip.empty?
        x["category_id"] = Category.find_by(name: "").id
      else
        category = Category.find_by(name: x["category_id"])
        if category
          x["category_id"] = category.id          
        else
          x["category_id"] = Category.find_by(name: "").id
        end
      end
    else
      p "category_id=#{x["category_id"]}"
      raise
    end

    x.delete("readstatus")
    x.delete("read_status")
    x.delete("shape")
    x.delete("bookstore")
    x.delete("category")
    x
  end

  def make_reg_list(hash)
    reg_hash = {}
    hash.each do |field, array|
      array.each do |str|
        escaped_str = Regexp.escape(str)
        reg_hash[field] ||= []
        reg_hash[field] << Regexp.new(escaped_str)
      end
    end
    reg_hash
  end

  def get_year_and_item(key: nil, year: nil)
    if year.nil?
      if key.nil?
        return nil 
      else
        item = @vx[:category][@name][year]
        year = item.year  
      end
    else
      if key
        item = @vx[:key][key]
        if item
          year = item.year 
        end
      end
    end

    if @vx[:category].nil? ||
       @vx[:category][@name].nil? ||
       @vx[:category][@name][year].nil?
      # @logger.debug "book return 1"
      return nil
    end

    [year, item]
  end

  def load_data(item:, year: nil)
    path = item.full_path
    JsonUtils.parse(path)
  end

  def xf_booklist(year: nil, key: nil, mode: :register)
    @detector = DetectorImporter.new()
    data_array = []

    if @vx[:category].nil? ||
       @vx[:category][@name].nil?
      return
    end
  
    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }

    array = get_year_and_item(key: key, year: year)
    unless array
      return
    end
  
    year, item = array

    base_number = year * 1000
    json = load_data(item: item, year: year)
    if json.nil?
      return
    end
    new_json = @detector.detect_replace_key_x(json, @keys["key_replace"])
    new_json_second = @detector.complement_key_x(new_json, @keys["key_complement"])

    new_json_second.delete("")

    keys = new_json_second.keys
    keys.each do |k|
      delete_key(new_json_second[k], @delkeys)
    end
    keys.each do |k|
      new_json_second[k].delete("")
    end
    keys.each do |k|
      xf_supplement(new_json_second[k], new_json_second[k])
    end
    keys.each do |k|
      # @detector.detect_blank(new_json_second, new_json_second)
      detect_blank(@detector, new_json_second[k])
    end
    keys.each do |k|
      if new_json_second[k]["totalid"]
        new_json_second[k]["totalID"] = new_json_second["totalid"]
        new_json_second[k].delete("totalid")
      end
      new_json_second[k]["totalID"] = new_json_second["xid"].to_i + base_number if new_json_second["totalID"]
      new_json_second[k]["xid"] = new_json_second["xid"].to_i + base_number if new_json_second[k]["xid"]
    end


    # @logger.debug x
    # select_valid_data(new_json_second, "purchase_date", "asin", Booklist, data_array)
    keys.each do |k|
      select_valid_data_y(new_json_second[k], data_array)
    end

    count = @detector.show_detected
    #
    @logger.debug "data_array=#{data_array}"

    ret = false
    if mode == :register && count.zero? && data_array.size.positive?
      @ar_klass.insert_all( data_array )
      ret = true 
    else
      LoggerUtils.log_debug_p "#### xf_booklist S"
      LoggerUtils.log_debug_p "mode=#{mode}"
      LoggerUtils.log_debug_p "count=#{count}"
      LoggerUtils.log_debug_p "data_array.size=#{data_array.size}"
      LoggerUtils.log_debug_p "#### xf_booklist E"
    end
    @detector.show_detected()

    ret
  end
end
