class BaseImporter
  def initialize(vx, keys, ks)
    @vx = vx
    p "BaseImporter keys=#{keys}"
    @keys = keys
    @delkeys = @keys["remove"]
    @ks = ks
    @ignore_field_list ||= %W()
    @ignore_field_value_hash ||= {}
  end

  def show(key, index)
    path = @vx[key][index]
    json = JSON.parse(File.read(path))
    p json
  end

  def xf_begin(year)
    p @name
    k = @ks[@name].find { |value|
      year == value.split("|")[5].to_i
    }
    p year
    p @ks
    p @name
    p @ks[@name]
    p k
    key = @ks[k][0]
    # path = @vx[k][0]
    path = @vx[key]
    puts "k=#{k}"
    puts "path=#{path}"
    @json = JSON.parse(File.read(path))
    # pp @json

    blank_field_init
    duplicated_field_init
  end

  def xf_supplement(target, x, basenumber = nil)
    x.map { |k, v|
      next if @ignore_field_list.find(k)
      find_duplicated_field_value(target, k, x)
    }
    x
  end

  def xf(i, mode = :none)
    @detector = DetectorImporter.new()
    data_array = []

    @detector.blank_field_init()
    @detector.duplicated_field_init()

    xf_begin(i)
    @json.map { |x|
      @delkeys.map { |k| x.delete(k) }
      x.delete("")

      x = xf_supplement(x, x)

      @detector.detect_blank(x, x)
      data_array << x
    }
    count = @detector.show_detected

    @ar_klass.insert_all(data_array) if mode == :register && count == 0
  end
end
