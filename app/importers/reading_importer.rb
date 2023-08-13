class ReadingImporter < BaseImporter
  def initialize(vx, keys, ks)
    super(vx, keys, ks)
    @name = "reading"
    @ar_klass = Readinglist
  end
=begin
  def xf_supplement(x, base_number = nil)
    rec = {}
    rec[:register_date] = x["登録日"]
    rec[:date] = x["日付"]
    rec[:title] = x["書名"]
    rec[:status] = x["状態"]
    rec[:shape] = x["形態"]
    rec[:isbn] = x["ISBN"]
    rec
  end
=end
  def xf_reading(key, mode = :register)
    data_array = []
    @detector = DetectorImporter.new()

    if @vx[:category] == nil ||
       @vx[:category][@name] == nil
      return
    end

    item = @vx[:key][key]
    path = item.full_path
    # p path
    # exit 0
    @detector.register_ignore_blank_field("isbn")
    @detector.register_ignore_blank_field("ISBN")

    json = JsonUtils.parse(path)

    new_json = @detector.detect_replace_key(json, @keys["key_replace"])
    new_json_2 = @detector.cmoplement_key(new_json, @keys["key_complement"])

    new_json_2.map { |x|
      @delkeys.map { |k| x.delete(k) }

      x.map { |k, v|
        next if @ignore_field_list.find(k)
        @detector.find_duplicated_field_value(x, k, x)
      }
      @detector.detect_blank(x, x)

      str = x["status"]
      p "x=#{str}"
      str2 = x[:status]
      p "x=#{str2}"
      p x
      x[:readstatus_id] = Readstatus.find_by(name: x["status"]).id

      data_array << x
    }

    # new_json_2.map { |jso|
    #   data_array << jso
    # }
    # p "data_array=#{data_array}"
    count = @detector.show_detected()
    p "count=#{count}"
    @ar_klass.insert_all(data_array) if mode == :register && count == 0
  end
end
