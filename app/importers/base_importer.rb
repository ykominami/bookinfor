require 'pp'

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

  def set_assoc(x, klass, oldname, newname = nil)
    if newname.nil?
      key = oldname + "_id"
    else
      key = newname
    end
    x[key] = x[oldname]
  end

  def set_assoc_0(x, klass, oldname, newname = nil)
    if newname.nil?
      key = oldname + "_id"
    else
      key = newname
    end
    #
    @logger.debug "BaseImporter#set_assoce klass=#{klass} oldname=#{oldname} newname=#{newname}"
    @logger.debug "x=#{x}"
    #
    if x[oldname].instance_of?(Integer)
      x[key] = x[oldname]
    elsif x[oldname].instance_of?(String)
      s = klass.find_by(name: x[oldname])
      if s
        x[key] = s.id
      else
        s = klass.find_by(name: "")
        if s
            x[key] = s.id
        else
          p "oldname=#{oldname} | #{x[oldname]} | key=#{key}"
          p "klass.find_by(name: " + ") s=#{s} klass=#{klass} klass.all.size=#{klass.all.size}"
          raise
        end
      end      
    else
      s = klass.find_by(name: "")
      if s
        x[key] = s.id
      else
        p "klass.find_by(name: " + ") s=#{s} klass=#{klass} klass.all.size=#{klass.all.size}"
        raise
      end
    end
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

  def xf(key:, year: nil, mode: :register) # rubocop:disable Lint/UnusedMethodArgument
    p "BaseImporter#xf key=#{key} year=#{year} mode=#{mode}"
    @detector = DetectorImporter.new()
    data_array = []

    @key = key

    if @vx[:category].nil? ||
       @vx[:category][@name].nil?
      return
    end
    p "BaseImporter#xf 2 key=#{key} year=#{year} mode=#{mode}"

    @ignore_fields.map { |field| @detector.register_ignore_blank_field(field) }

    json = load_data()
    if json.nil?
      msg = "json is nil in BaseImporter#xf"
      LoggerUtils.log_debug_p(msg, @logger)
      return
    end
    p "BaseImporter#xf 3 key=#{key} year=#{year} mode=#{mode}"

    new_json = @detector.detect_replace_key_x(json, @keys["key_replace"])
    new_json_second = @detector.complement_key_x(new_json, @keys["key_complement"])
  
    new_json_second.delete("")

    col_keys = new_json_second.keys
    col_keys.each do |col_k|
      delete_key(new_json_second[col_k], @delkeys)
      after_delete_key(new_json_second[col_k], @after_delkeys)
    end
    col_keys.each do |col_k|
      new_json_second[col_k].delete("")
    end
    col_keys.each do |col_k|
      xf_supplement(new_json_second[col_k])
    end
    col_keys.each do |col_k|
      detect_blank(@detector, new_json_second[col_k])
    end
    col_keys.each do |col_k|
      new_json_second[col_k].each_key do |col_k2|
        next if @ignore_fields.find(col_k2)

        @detector.find_duplicated_field_value(col_k, col_k2, new_json_second[col_k])
      end
    end
    # readstatus=new_json_second
    col_keys.each do |col_k|
      @logger.debug "xf col_k=#{col_k}"
      @logger.debug "data_array.size=#{data_array.size}"
      @logger.debug "data_array[0]=#{data_array[0]}"
      # select_valid_data_x(readstatus, data_array)
      readstatus = new_json_second[col_k]
      if new_json_second[col_k].instance_of?(Hash)
        select_valid_data_y(new_json_second[col_k], data_array)
      else
        p "new_json_second[col_k].class=#{new_json_second[col_k].class}"
        raise
      end
    end
    count = @detector.show_detected()
    return unless mode == :register && count.zero? && data_array.size.positive?

    begin
      @ar_klass.insert_all( data_array )
    rescue StandardError => exc
      exc_msg = exc.class
      LoggerUtils.log_fatal_p exc_msg
      p exc_msg
      exc_msg = "Excception from @ar_klass.insert_all(data_array)"
      LoggerUtils.log_fatal_p exc_msg
      p exc_msg
      exc_msg = exc.message
      LoggerUtils.log_fatal_p exc_msg
      p exc_msg
      p "BaseImporter#xf 4 key=#{key} year=#{year} mode=#{mode}"

      raise
    end
  end

  def show(key, index)
    path = @vx[key][index]
    JSON.parse(File.read(path))
    # @logger.info json
  end

  def load_data
    item = @vx[:key][@key]
    if item.nil?
      p "exit BaseImporter#load_data"
      exit
    end
    path = item.full_path
    p "BaseImporter path=#{path}"
    normalize_loaded_json(JsonUtils.parse(path))
  end

  def valid_date?(target_date)
    if ConfigUtils.use_import_date?
      @import_date.before? target_date
    else
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

  private

  # API/ダウンロードJSONが [[ヘッダ行], [データ行]...] のとき、xf が期待する
  # { "0" => { 列名 => 値, ... }, ... } 形式へ揃える。
  def normalize_loaded_json(json)
    return json if json.nil? || !json.is_a?(Array)
    return {} if json.empty?

    if json.first.is_a?(Array)
      headers = json[0]
      return {} unless headers.is_a?(Array)

      json[1..].each_with_index.with_object({}) do |(row, i), acc|
        next unless row.is_a?(Array)

        row_hash = {}
        headers.each_with_index { |hkey, j| row_hash[hkey] = row[j] }
        acc[i.to_s] = row_hash
      end
    elsif json.first.is_a?(Hash)
      json.each_with_index.with_object({}) { |(row, i), acc| acc[i.to_s] = row }
    else
      json
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
      rescue StandardError => exc
        @logger.debug("1 Date parse error: #{exc.message} target=#{target}")
      end
    else
      target_date = target
    end

    return unless target_date.instance_of?(Date)

    return unless valid_date?(target_date)

    value = x[unique_field]
    record = ac_klass.find_by(unique_field.to_sym => value)
    return if record

        append_data(x, data_array) 
    
  end
end
