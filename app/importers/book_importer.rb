class BookImporter < BaseImporter
  class BookDetectorImporter < DetectorImporter
    def initialize
      @logger = LoggerUtils.logger()
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
    select_valid_data(x, "purchase_date", "asin", Booklist, data_array)
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

    set_assoc(x, Category, "read_status", "readstatus")
    set_assoc(x, Bookstore, "bookstore", "bookstore")

    x["shape_id"] = x["shape"]
    case x["shape"]
    when 3
      # @logger.debug "X shape=3"
      case x["bookstore"]
      when "紀伊國屋書店名古屋空港店" | "TSUTAYA春日井店" | "TSUTAYA春 日 井 店"
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

  def readstatus=(x)
    # status = Readstatus.find_by(name: x["read_status"])
    # @logger.debug "status=#{status} read_status=#{x["read_status"]}"
    # x[:readstatus_id] = status != nil ? status.id : 1
    x[:readstatus_id] = x["read_status"].to_i + 1
    x.delete("read_status")
  end

  def xf_booklist(year: nil, key: nil, mode: :register)
    # raise

    @detector = DetectorImporter.new()
    data_array = []

    return if @vx[:category].nil? || @vx[:category][@name].nil?

    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }

    array = get_year_and_item(key: key, year: year)
    return unless array

    year, item = array

    base_number = year * 1000
    # raise
    json = load_data(item: item, year: year)
    # @logger.debug json
    # raise
    new_json = @detector.detect_replace_key(json, @keys["key_replace"])
    new_json_second = @detector.cmoplement_key(new_json, @keys["key_complement"])

    new_json_second.map do |x|
      # @logger.debug x
      # raise
      @delkeys.map { |k| x.delete(k) }
      if x["totalid"]
        x["totalID"] = x["totalid"]
        x.delete("totalid")
      end
      x.delete("")
      x["totalID"] = x["xid"].to_i + base_number if x["totalID"]
      x["xid"] = x["xid"].to_i + base_number if x["xid"]

      xf_supplement(x, x)

      @detector.detect_blank(x, x)

      readstatus=x

      # @logger.debug x
      select_valid_data(x, "purchase_date", "asin", Booklist, data_array)
    end
    count = @detector.show_detected
    @ar_klass.insert_all(data_array) if mode == :register && count.zero? && data_array.size.positive?
    @detector.show_detected()
  end
end
