class BaseImporter
  def initialize(vx, keys, ks)
    @vx = vx
    # p "BaseImporter keys=#{keys}"
    @keys = keys
    @delkeys = @keys["remove"]
    @ks = ks
    @ignore_fields ||= %W()
  end

  def set_readstatus(x)
    status = Readstatus.find_by(name: x["status"])
    x["readstatus_id"] ||= (status != nil ? status.first.id : 1)
  end

  def xf_supplement(target, x, base_number = nil)
  end

  def detect_blank(inst, x)
    inst.detect_blank(x, x)
  end

  def select_valid_data_x(x, data_array)
  end

  def xf(key, mode = :register)
    @detector = DetectorImporter.new()
    data_array = []
    @key = key

    if @vx[:category] == nil ||
       @vx[:category][@name] == nil
      return
    end

    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }
    # p @ignore_fields
    # p @detector.ignore_blank_keys

    json = load_data()
    new_json = @detector.detect_replace_key(json, @keys["key_replace"])
    new_json_2 = @detector.cmoplement_key(new_json, @keys["key_complement"])

    # p "import_date=#{import_date}"
    new_json_2.map { |x|
      @delkeys.map { |k| x.delete(k) }

      xf_supplement(x, x)
      x.map { |k, v|
        next if @ignore_fields.find(k)
        @detector.find_duplicated_field_value(x, k, x)
      }
      x.delete("")
      detect_blank(@detector, x)

      # @detector.detect_blank(x, x)

      set_readstatus(x)

      select_valid_data_x(x, data_array)
      # select_valid_data(x, "purchase_date", "asin", Kindlelist, data_array)
      #exit
    }
    count = @detector.show_detected()
    if mode == :register && count == 0 && data_array.size > 0
      @ar_klass.insert_all(data_array)
    end
  end

  def show(key, index)
    path = @vx[key][index]
    json = JSON.parse(File.read(path))
    # p json
  end

  def load_data
    item = @vx[:key][@key]
    path = item.full_path
    JsonUtils.parse(path)
  end

  def valid_date?(target_date)
    if ConfigUtils.use_import_date
      # p "kindle_importer valid_date? 1"
      @import_date.before? target_date
    else
      # p "kindle_importer valid_date? 2"
      true
    end
  end

  def get_import_date
    date_str = @import_date
    # p "date_str=#{date_str}"
    if date_str && date_str != ""
      # p "get_import_date 1"
      import_date = Date.parse(date_str)
    else
      # p "get_import_date 2"
      import_date = Date.new(1970, 1, 1)
    end
    # baseline = Date.new(2023, 7, 10)
    import_date
  end

  def append_data(x, data_array, use_check = true)
    if use_check
      detect_blank(@detector, x)
      data_array << x
    else
      puts "append_data check_flag=true"
    end
  end

  def select_valid_data(x, date_field, unique_field, ac_klass, data_array)
    target = x[date_field]
    if target.instance_of?(String)
      target_date = Date.parse(target)
    else
      target_date = target
    end
    if valid_date?(target_date)
      value = x[unique_field]
      if ac_klass.find_by(unique_field.to_sym => value) != nil
        # p "=1 value=#{value}"
      else
        # p "2 value=#{value}"
        append_data(x, data_array)
      end
    end
  end
end
