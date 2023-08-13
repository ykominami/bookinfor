class CalibreImporter < BaseImporter
  class CalibreDetectorImporter < DetectorImporter
    def show_detected()
      count = super()
      count += show_duplicated_field("title")
      count
    end

    def blank_field_init()
      super()
      @blank_keys["cover"] = 0
    end
  end

  def initialize(vx, keys, ks)
    super(vx, keys, ks)
    @name = "calibre"
    @ar_klass = Calibrelist
    @field_list = %W(isbn series comments publisher size tags identifiers rating formats)

    @ignore_field_list = @field_list + %W(series_index library_name languages zid authors author_sort pubdate)
  end

  def xf_supplement(target, x, base_number = nil)
    x["zid"] = x["xid"]
    # p x
    super(target, x, base_number)
  end

  def xf_calibre(key, mode = :register)
    @detector = CalibreDetectorImporter.new()
    data_array = []

    if @vx[:category] == nil ||
       @vx[:category][@name] == nil
      return
    end

    item = @vx[:key][key]
    path = item.full_path

    @detector.blank_field_init()
    @detector.duplicated_field_init()
    @field_list.map { |field| @detector.register_ignore_blank_field(field) }

    json = JsonUtils.parse(path)
    #p json[0]
    #p json[1]

    new_json = @detector.detect_replace_key(json, @keys["key_replace"])
    new_json_2 = @detector.cmoplement_key(new_json, @keys["key_complement"])

    new_json_2.map { |x|
      @delkeys.map { |k| x.delete(k) }
      x.delete("")

      @detector.detect_blank(x, x)
      xf_supplement(x, x)
      data_array << x
    }
    p data_array[0]
    p data_array[1]

    @ar_klass.insert_all(data_array) if mode == :register

    @detector.show_detected()
  end
end
