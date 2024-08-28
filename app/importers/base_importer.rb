class BaseImporter
  def initialize(vx, keys, ks)
    @logger = LoggerUtils.logger()

    @vx = vx
    @logger.debug "BaseImporter keys=#{keys}"
    @keys = keys
    @delkeys = @keys["remove"]
    #
    @after_delkeys = @keys["after_remove"]
    @after_delkeys ||= []
    #
    @ks = ks
    @ignore_fields ||= %w[]
  end

  def set_assoc(x, klass, oldname, newname)
    key = newname + "_id"
    x[key] = x[oldname]
    #
    p "BaseImporter#set_assoce klass=#{klass} olbname=#{oldname} newname=#{newname}"
    p "x=#{x}"
    #
    # s = klass.find_by(name: x[newname])
    s = klass.find_by(name: x[key])
    if s
      x[key] = s.id
    else
      x[key] = 1
      # @logger.debug x
    end
  end

  def readstatus=(x)
    status = x["status"]
    # @logger.debug "readstatus= status=#{status}"
    return if status.nil?

    status = Readstatus.find_by(name: status)
    x["readstatus_id"] ||= (status.nil? ? 1 : status.first.id)
  end

  def xf_supplement(target, x, base_number = nil); end

  def detect_blank(inst, x)
    inst.detect_blank(x, x)
  end

  def select_valid_data_x(x, data_array); end

  def xf(key, mode = :register)
    @detector = DetectorImporter.new()
    data_array = []
    @key = key

    if @vx[:category].nil? ||
       @vx[:category][@name].nil?
      return
    end

    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }
    # @lpgger.debug @ignore_fields
    # @logger.debug @detector.ignore_blank_keys

    json = load_data()
    new_json = @detector.detect_replace_key(json, @keys["key_replace"])
    new_json_second = @detector.cmoplement_key(new_json, @keys["key_complement"])

    # @logger.debug "import_date=#{import_date}"
    new_json_second.map do |x|
      @delkeys.map { |k| x.delete(k) }
      @after_delkeys.map { |k| x.delete(k) }
      puts "xf x=#{x}"

      xf_supplement(x, x)

      x.map do |k, _v|
        next if @ignore_fields.find(k)

        @detector.find_duplicated_field_value(x, k, x)
      end
      x.delete("")
      detect_blank(@detector, x)

      # @detector.detect_blank(x, x)

      readstatus=x

	p "xf key=#{key}"
        p "data_array.size=#{data_array.size}"
        p "data_array[0]=#{data_array[0]}"
      select_valid_data_x(readstatus, data_array)
      # select_valid_data(x, "purchase_date", "asin", Kindlelist, data_array)
      # exit
    end
    count = @detector.show_detected()
    return unless mode == :register && count.zero? && data_array.size.positive?

    begin
      @ar_klass.insert_all(data_array)
    rescue StandardError => exc
      pp @ar_klass
      pp exc.class
      pp exc.message
      pp exc.backtrace
	
      exit
    end
  end

  def show(key, index)
    path = @vx[key][index]
    JSON.parse(File.read(path))
    # @logger.info json
  end

  def load_data
    item = @vx[:key][@key]
    path = item.full_path
    # @logger.debug "load_data path=#{path}"
    # raise

    JsonUtils.parse(path)
  end

  def valid_date?(target_date)
    if ConfigUtils.use_import_date?
      # @logger.debug "kindle_importer valid_date? 1"
      @import_date.before? target_date
    else
      # @logger.debug "kindle_importer valid_date? 2"
      true
    end
  end

  def import_date
    date_str = @import_date
    if date_str && date_str != ""
      import_date = Date.parse(date_str)
    else
      import_date = Date.new(1970, 1, 1)
    end
    import_date
  end

  def append_data(x, data_array, use_check: true)
    if use_check
      detect_blank(@detector, x)
      data_array << x
    else
      @logger.debug "append_data use_check=true"
    end
  end

  def select_valid_data(x, date_field, unique_field, ac_klass, data_array)
    target = x[date_field]
    return if UtilUtils.nil_or_empty_string?(target)

    if target.instance_of?(String)
      begin
        target_date = Date.parse(target)
      rescue Date::Error => exc
        @logger.debug("0 Date parse error: #{exc.message} target=#{target}")
        ""
      rescue StandardError => exc
        @logger.debug("1 Date parse error: #{exc.message} target=#{target}")
        nil
      end
      return if UtilUtils.nil_or_empty_string?(target)

    else
      target_date = target
    end

    return unless target_date.instance_of?(Date)

    return unless valid_date?(target_date)

    value = x[unique_field]
    append_data(x, data_array) unless ac_klass.find_by(unique_field.to_sym => value)
  end
end
