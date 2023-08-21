class BookImporter < BaseImporter
  class BookDetectorImporter < DetectorImporter
    def show_detected
      #show_blank_fields
      #show_duplicated_fields
      # puts "# show_detected (ImporterBook) S"

      count = super()
      count += show_duplicated_field("title")
      # puts "# show_detected (ImporterBook) E"
      count
    end

    def detect(target, reg_hash)
      ret = reg_hash.find { |key, reg_array|
        retb = reg_array.find { |reg|
          word = target[key]
          reta = reg.match(word)
          reta != nil
        }
        retb != nil
      }
      ret
    end

    def detect_ignore_items(target, reg_hash)
      detect(target, reg_hash) != nil
    end
  end

  def initialize(vx, keys, ks, import_date)
    super(vx, keys, ks)
    @detector = BookDetectorImporter.new()
    @name = "book"
    @ar_klass = Booklist
    @import_date = import_date
    @ignore_fields = %W(isbn series comments rating identifiers)
  end

  def select_valid_data_x(x, data_array)
    select_valid_data(x, "purchase_date", "asin", Booklist, data_array)
  end

  def xf_supplement(target, x, base_number = nil)
    if x["totalid"]
      x["totalID"] = x["totalid"]
      x.delete("totalid")
    end
    if x["totalID"]
      x["totalID"] = x["xid"].to_i + base_number
      find_duplicated_field_value(target, "totalID", x)
    end
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
    if key != nil
      if year != nil
        # puts "book return 2"
        return
      else
        item = @vx[:key][key]
        year = item.year
      end
    else
      if year != nil
        item = @vx[:category][@name][year]
      else
        # puts "book return 3"
        return
      end
    end

    if @vx[:category] == nil ||
       @vx[:category][@name] == nil ||
       @vx[:category][@name][year] == nil
      # puts "book return 1"
      return
    end

    [year, item]
  end

  def load_data(item:, year: nil)
    path = item.full_path
    # puts "path=#{path}"
    JsonUtils.parse(path)
  end

  def set_readstatus(x)
    status = Readstatus.find_by(name: x["read_status"])
    x[:readstatus_id] = status != nil ? status.id : 1
  end

  def xf_booklist(year: nil, key: nil, mode: :register)
    @detector = DetectorImporter.new()
    data_array = []

    if @vx[:category] == nil ||
       @vx[:category][@name] == nil
      return
    end

    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }

    array = get_year_and_item(key: key, year: year)
    return unless array
    year, item = array

    base_number = year * 1000

    json = load_data(item: item, year: year)

    new_json = @detector.detect_replace_key(json, @keys["key_replace"])
    new_json_2 = @detector.cmoplement_key(new_json, @keys["key_complement"])

    new_json_2.map { |x|
      @delkeys.map { |k| x.delete(k) }
      if x["totalid"]
        x["totalID"] = x["totalid"]
        x.delete("totalid")
      end
      x.delete("")
      if x["totalID"]
        x["totalID"] = x["xid"].to_i + base_number
      end
      if x["xid"]
        x["xid"] = x["xid"].to_i + base_number
      end
      @detector.detect_blank(x, x)

      set_readstatus(x)

      select_valid_data(x, "purchase_date", "asin", Booklist, data_array)
    }
    count = @detector.show_detected
    if mode == :register && count == 0 && data_array.size > 0
      @ar_klass.insert_all(data_array)
    end
    @detector.show_detected()
  end
end
