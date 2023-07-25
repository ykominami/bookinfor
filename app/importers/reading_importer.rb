class ReadingImporter < BaseImporter
  def initialize(vx, keys, ks)
    super(vx, keys, ks)
    @name = "reading"
    @ar_klass = Readinglist
  end

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

  def xf_reading(key, mode = :register)
    data_array = []
    @detector = DetectorImporter.new()

    if @vx[:category] == nil ||
      @vx[:category][@name] == nil
     return
    end

    item = @vx[:key][ key ]
    path = item.full_path
    p path
    # exit 0
      
    json = JsonUtils.parse(path)
    json.map { |jso|
      js = jso
      rec = {}
      rec[:register_date] = js["登録日"]
      rec[:date] = js["日付"]
      rec[:title] = js["書名"]
      rec[:status] = js["状態"]
      rec[:shape] = js["形態"]
      rec[:isbn] = js["ISBN"]
      data_array << rec
    }
    # p "data_array=#{data_array}"
    count = @detector.show_detected()

    @ar_klass.insert_all(data_array) if mode == :register && count == 0
  end
end
