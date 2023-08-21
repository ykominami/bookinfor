class ReadingImporter < BaseImporter
  def initialize(vx, keys, ks, import_date)
    super(vx, keys, ks)
    @name = "reading"
    @ar_klass = Readinglist
    @import_date = import_date
    @ignore_fields = %w(isbn ISBN)
  end

  def detec_blank(inst, x)
    inst.detect_blank(x, x)
  end

  def select_valid_data_x(x, data_array)
    select_valid_data(x, "register_date", "isbn", Readinglist, data_array)
  end

  def xf_reading(key, mode = :register)
    @detector = DetectorImporter.new()
    data_array = []
    @key = key

    if @vx[:category] == nil ||
       @vx[:category][@name] == nil
      return
    end

    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }

    json = load_data()
    new_json = @detector.detect_replace_key(json, @keys["key_replace"])
    new_json_2 = @detector.cmoplement_key(new_json, @keys["key_complement"])

    new_json_2.map { |x|
      @delkeys.map { |k| x.delete(k) }

      x.map { |k, v|
        next if @ignore_fields.find(k)
        @detector.find_duplicated_field_value(x, k, x)
      }
      detec_blank(@detector, x)

      set_readstatus()

      select_valid_data(x, "register_date", "isbn", Readinglist, data_array)
    }
    count = @detector.show_detected()
    if mode == :register && count == 0 && data_array.size > 0
      @ar_klass.insert_all(data_array)
    end
  end
end
