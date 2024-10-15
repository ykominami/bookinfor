class BookImporter < BaseImporter
  class BookDetectorImporter < DetectorImporter
    def initialize
      @logger = LoggerUtils.logger()
      @logger.tagged("#{self.class.name}")
    end

    def show_detected
      # show_blank_fields
      # show_duplicated_fields
      # @logger.debug "# show_detected (ImporterBook) S"

      count = super()
      count += show_duplicated_field("title")
      # @logger.debug "# show_detected (ImporterBook) E"
      count
    end

    def detect(target, reg_hash)
      reg_hash.find do |key, reg_array|
        retb = reg_array.find do |reg|
          word = target[key]
          reta = reg.match(word)
          !reta.nil?
        end
        !retb.nil?
      end
    end

    def detect_ignore_items(target, reg_hash)
      !detect(target, reg_hash).nil?
    end
  end

  def initialize(vx, keys, ks, import_date)
    @logger = LoggerUtils.logger()

    super(vx, keys, ks)
    @detector = BookDetectorImporter.new()
    @name = "book"
    @ar_klass = Booklist
    @import_date = import_date
    # raise

    @ignore_fields = %w[isbn series comments rating identifiers]
  end

  def select_valid_data_x(x, data_array)
    # p "#### book_importer#select_valid_data_x"
    # raise
    keys = x.keys
    keys.each do |k|
      if x[k].instance_of?(Hash)
        select_valid_data_y(x[k], data_array)
      else
        p "#### book_importer#select_valid_data_x x[#{k}].class=#{x[k].class}"
      end
    end
  end

  def select_valid_data_y(x, data_array)
    if x.instance_of?(Hash)
      select_valid_data(x, "purchase_date", "asin", Booklist, data_array)
    else
      p "#### book_importer#select_valid_data_y x.class=#{x.class}"
    end
  end

  def xf_supplement(target, x, base_number = 0)
    # raise

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
    set_assoc(x, Bookstore, "bookstore", "bookstore")

    case x["shape"]
    when 3
      # @logger.debug "X shape=3"
      case x["bookstore"]
      when /紀伊國屋書店名古屋空港店|TSUTAYA春日井店|TSUTAYA春 日 井 店/
        # @logger.debug x["bookstore"]
        x["shape"] = Shape.find_by(name: "CD/DVD/BD").id
      when "あおい書店西春店"
        # @logger.debug x["bookstore"]
        # x["shape"] = Shape.find_by(name: "その他").id
      when "アマゾン(Kindle)"
        # @logger.debug "SHAPE -Kindle"
        # @logger.debug x["bookstore"]
        x["shape"] = Shape.find_by(name: "Kindle").id
        # @logger.debug "kindle =#{x["shape"]}"
        # raise
      when "アマゾン(Kindle unlimited)"
        # @logger.debug "SHAPE -Kindle un"
        # @logger.debug x["bookstore"]
        x["shape"] = Shape.find_by(name: "Kindle-U").id
      else
        @logger.debug "SHAPE -else"
        @logger.debug x["bookstore"]
        @logger.debug "Not found bookstore #{x["bookstore"]}"
        raise
      end
    end
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
        # p "category_id=#{x["category_id"]}"
        category = Category.find_by(name: x["category_id"])
        if category
          x["category_id"] = category.id          
          p "1 category_id=#{x["category_id"]}"
        else
          x["category_id"] = Category.find_by(name: "").id
          p "2 category_id=#{x["category_id"]}"
          # raise
        end
      end
    else
      p "category_id=#{x["category_id"]}"
      raise
    end

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
    if key.nil?
      return if year.nil?

      item = @vx[:category][@name][year]
    else
      return unless year.nil?

      item = @vx[:key][key]
      year = item.year
    end

    if @vx[:category].nil? ||
       @vx[:category][@name].nil? ||
       @vx[:category][@name][year].nil?
      # @logger.debug "book return 1"
      return
    end

    [year, item]
  end

  def load_data(item:, year: nil)
    path = item.full_path
    # @logger.debug "path=#{path}"
    # raise
    JsonUtils.parse(path)
  end

  def xf_booklist(year: nil, key: nil, mode: :register)
    # raise

    @detector = DetectorImporter.new()
    data_array = []

    if @vx[:category].nil? ||
       @vx[:category][@name].nil?
      p "book_importer xf_booklist -1"
      return
    end
  
    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }

    array = get_year_and_item(key: key, year: year)
    unless array
      p "book_importer xf_booklist -2"
      return
    end
  
    year, item = array

    base_number = year * 1000
    # raise
    json = load_data(item: item, year: year)
    if json.nil?
      @logger.debug "json is nil in BookImporter#xf_booklist"
      p "book_importer xf_booklist -3"
      return
    end
    # @logger.debug json
    # raise
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
    # raise

    count = @detector.show_detected
    #
    p "============= bookimporter xf_booklist count=#{count}"
    @logger.debug "data_array=#{data_array}"
    if mode == :register && count.zero? && data_array.size.positive?
      p "data_array.size=#{data_array.size}"
      p data_array[0]
      @ar_klass.insert_all( data_array ) 
    else
      p "#### xf_booklist S"
      p "mode=#{mode}"
      p "count=#{count}"
      p "data_array.size=#{data_array.size}"
      p "#### xf_booklist E"
    end
    @detector.show_detected()
  end
end
