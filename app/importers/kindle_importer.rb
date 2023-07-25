class KindleImporter < BaseImporter
  def initialize(vx, keys, ks)
    super(vx, keys, ks)
    @name = "kindle"
    @ignore_field_list = %W(publisher author publish_date purchase_date read_status category)
    @ar_klass = Kindlelist
  end

  def xf_supplement(targe, x, base_number = nil)
    x.map { |k, v|
      next if @ignore_field_list.find(k)
      find_duplicated_field_value(target, k, x)
    }
    x
  end

  def xf_kindle( key, mode = :register)
    @detector = DetectorImporter.new()
    data_array = []

    if @vx[:category] == nil ||
      @vx[:category][@name] == nil
     return
    end

    item = @vx[:key][ key ]
    path = item.full_path

    # @detector.blank_field_init()

    # json = JSON.parse(File.read(path))
    json = JsonUtils.parse(path)

    @detector.register_ignore_blank_field("publisher")
    @detector.register_ignore_blank_field("publish_date")
    
    json.map { |x|
      @delkeys.map { |k| x.delete(k) }

      x.map { |k, v|
        next if @ignore_field_list.find(k)
        @detector.find_duplicated_field_value(x, k, x)
      }
      @detector.detect_blank(x, x)
      data_array << x
    }
    count = @detector.show_detected()

    @ar_klass.insert_all(data_array) if mode == :register && count == 0
  end
end
