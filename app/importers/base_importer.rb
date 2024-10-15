class BaseImporter
  def initialize(vx, keys, ks)
    @logger = LoggerUtils.logger()
    @logger.tagged("#{self.class.name}")

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
    #
    @logger.debug "BaseImporter#set_assoce klass=#{klass} olbname=#{oldname} newname=#{newname}"
    @logger.debug "x=#{x}"
    #
    if x[oldname].instance_of?(Integer)
      p "base_importer set_assoc 1 klass=#{klass} x[oldname]=#{x[oldname]}"
      x[key] = x[oldname]
      p "1 set_assoc x[#{key}]=#{x[key]}"
    elsif x[oldname].instance_of?(String)
      p "base_importer set_assoc 2 klass=#{klass} x[oldname]=#{x[oldname]}"
      s = klass.find_by(name: x[oldname])
      if s
        x[key] = s.id
        p "2 set_assoc x[#{key}]=#{x[key]}"
      else
        s = klass.find_by(name: "")
        if s
            x[key] = s.id
            p "3 set_assoc x[#{key}]=#{x[key]}"
        else
          p "4 base_importer set_assoc 2 klass=#{klass} Can't get s"
          raise
        end
      end      
    else
      p "5 base_importer set_assoc 3 klass=#{klass} x[oldname]=#{x[oldname]}"
      s = klass.find_by(name: "")
      if s
        x[key] = s.id
        p "6 set_assoc x[#{key}]=#{x[key]}"
      else
        p "7 base_importer set_assoc 1 klass=#{klass} Can't get s"
        raise
      end
    end
    # s = klass.find_by(name: x[newname])
    p "set_assoc E x[#{key}]=#{x[key]}"
  end

  def readstatus=(x)
    status = x["status"]
    # @logger.debug "readstatus= status=#{status}"
    return if status.nil?

    status = Readstatus.find_by(name: status)
    x["readstatus_id"] ||= (status.nil? ? 1 : status.first.id)
  end

  def detect_blank(inst, x)
    inst.detect_blank(x, x)
  end

  def delete_key(x, delkeys)
    delkeys.map { |delkey| x.delete(delkey) }
  end

  def after_delete_key(x, after_delkeys)
    after_delkeys.map { |delkey| x.delete(delkey) }
  end

  def xf(key, mode = :register)
    # p "base_importer xf 0"
    @detector = DetectorImporter.new()
    data_array = []
    @key = key

    if @vx[:category].nil? ||
       @vx[:category][@name].nil?
       p "base_importer xf -1"
      return
    end
    # p "base_importer xf 1"

    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }
    # @lpgger.debug @ignore_fields
    # @logger.debug @detector.ignore_blank_keys

    json = load_data()
    if json.nil?
      @logger.debug "json is nil in BaseImporter#xf"
      p "base_importer xf -2"
      return
    end
    # p "base_importer xf 2"

    new_json = @detector.detect_replace_key_x(json, @keys["key_replace"])
    new_json_second = @detector.complement_key_x(new_json, @keys["key_complement"])
  
    new_json_second.delete("")

    keys = new_json_second.keys
    keys.each do |k|
      delete_key(new_json_second[k], @delkeys)
      after_delete_key(new_json_second[k], @after_delkeys)
    end
    keys.each do |k|
      new_json_second[k].delete("")
    end
    keys.each do |k|
      xf_supplement(new_json_second[k])
    end
    keys.each do |k|
      detect_blank(@detector, new_json_second[k])
    end
    keys.each do |k|
      new_json_second[k].each_key do |k2|
        next if @ignore_fields.find(k2)

        @detector.find_duplicated_field_value(k, k2, new_json_second[k])
      end
    end
    # readstatus=new_json_second
    keys.each do |k|
      @logger.debug "xf k=#{k}"
      @logger.debug "data_array.size=#{data_array.size}"
      @logger.debug "data_array[0]=#{data_array[0]}"
      # select_valid_data_x(readstatus, data_array)
      readstatus = new_json_second[k]
      if new_json_second[k].instance_of?(Hash)
        p "new_json_second[k]=#{new_json_second[k]}"
        select_valid_data_y(new_json_second[k], data_array)
      else
        p "base_importer xf 5 new_json_second[k].class=#{new_json_second[k].class}"
        raise
      end
    end
    # raise
    # exit
    count = @detector.show_detected()
    unless mode == :register && count.zero? && data_array.size.positive?
      p "base_importer xf -10"
      p "mode=#{mode}"
      p "count=#{count}"
      p "data_array.size=#{data_array.size}"
      return
    end

    p "base_importer xf 10"
    p data_array
    begin
      # p data_array
      # exit
      @ar_klass.insert_all( data_array )
    rescue StandardError => exc
      # pp @ar_klass
      pp exc.class
      pp "Excception from @ar_klass.insert_all(data_array)"
      pp exc.message
      # pp exc.backtrace
      p "base_importer xf -3"

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
    @logger.debug "load_data path=#{path}"
    # p "base_importer load_data path=#{path}"
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
    raise
  end

  def append_data(x, data_array, use_check: true)
    if use_check
      detect_blank(@detector, x)
      data_array << x
    else
      @logger.debug "append_data use_check=true"
    end
  end
=begin
  def select_valid_data_x(x, date_field, unique_field, ac_klass, data_array)
    keys = x.keys
    keys.each do |k|
      select_valid_data(x[k], date_field, unique_field, ac_klass, data_array)
    end
  end
=end
  private

  def select_valid_data(x, date_field, unique_field, ac_klass, data_array)
    # p "x.class=#{x.class}"
    # p "x=#{x}"
    # p "date_field=#{date_field}"
    target = x[date_field]
    if UtilUtils.nil_or_empty_string?(target)
      p "basee_importer select_valid_data 1 target=#{target}"
      p "date_field=#{date_field}"
      p "x=#{x}"
      return 
    end
    if target.instance_of?(String)
      begin
        target_date = Date.parse(target)
      rescue Date::Error => exc
        @logger.debug("0 Date parse error: #{exc.message} target=#{target}")
      rescue StandardError => exc
        @logger.debug("1 Date parse error: #{exc.message} target=#{target}")
      end
    else
      target_date = target
    end

    unless target_date.instance_of?(Date)
      p "basee_importer select_valid_data 3 target_date=#{target_date}"
      return
    end

    unless valid_date?(target_date)
      p "basee_importer select_valid_data 4 target_date=#{target_date}"
      return
    end

    value = x[unique_field]
    record = ac_klass.find_by(unique_field.to_sym => value)
    unless record
        append_data(x, data_array) 
      # p "base_importer#select_valid_data append #{unique_field}: #{value}"
    else
      p "base_importer#select_valid_data not append #{unique_field}: #{value}"
      p record
    end
  end
end
