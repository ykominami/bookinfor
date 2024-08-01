class DetectorImporter
  attr_reader :ignore_blank_keys

  def initialize
    @logger = LoggerUtils.get_logger()

    @_errors = {}
    @_errors[:target] ||= {}

    duplicated_field_init()
    blank_field_init()
  end

  def duplicated_field_init
    @values ||= {}
    @dup_fields ||= {}
    @dup_keys ||= {}
    @_errors[:duplicated] ||= []
  end

  def blank_field_init
    @blank_keys ||= {}
    @ignore_blank_keys ||= []
    @_errors[:blank] ||= []
  end

  def register_ignore_blank_field(name)
    @ignore_blank_keys << name
  end

  def detect_blank(target, x)
    ret = find_blank(x)
    return unless ret.size.positive?

    ret.keys.map do |key|
      next if @ignore_blank_keys.index(key)

      @_errors[:target][target] ||= []
      @_errors[:target][target] << [:blank, key]
      @_errors[:blank] << [target, "key=#{key}"]
      count_up(target, @blank_keys, key)
    end
  end

  def find_blank(hash)
    hash.select do |_k, v|
      [nil, ""].include?(v)
    end
  end

  def count_up(target, hash, key, value = nil)
    if value
      hash[key] ||= {}
      hash[key][value] ||= []
      hash[key][value] << target
    else
      hash[key] ||= []
      hash[key] << target
    end
  end

  def find_duplicated_field_value(target, key, fields)
    ret = false
    value = fields[key]
    if @values[key]
      if @values[key][value]
        ret = true
      else
        @values[key][value] = fields
      end
    else
      @values[key] = {}
      @values[key][value] = fields
    end
    if ret
      @dup_fields[key] ||= []
      @dup_fields[key] << @values[key][value] if @dup_fields[key].size.zero?
      @dup_fields[key] << fields

      @_errors[:target][target] ||= []
      @_errors[:target][target] << [:duplicated, key]
      @_errors[:duplicated] << [target, key]
      count_up(target, @dup_keys, key, value)
    end
    ret
  end

  def show_blank_fields
    num = @blank_keys.size
    if num.positive?
      @logger.debug "==== blank"
      @logger.debug @blank_keys.size
      @logger.debug @blank_keys[0]
      @logger.debug @_errors[:blank][0]
      @logger.debug "===="

      @logger.debug num
    end

    num
  end

  def show_duplicated_fields
    num = @dup_keys.size
    if num.positive?
      @logger.debug "==== duplicated"
      @logger.debug @dup_keys.size
      @logger.debug @dup_keys[0]
      @logger.debug @_errors[:duplicated][0]
      @logger.debug "===="

      @logger.debug num
    end
    num
  end

  def show_duplicated_field(key)
    num = @dup_fields.size
    if num.positive?
      @logger.debug "=== duplicated key=#{key}"
      @logger.debug @dup_fields[key]

      @logger.debug num
    end
    num
  end

  def show_detected
    # @logger.debug "# show_detected (Importer) S"
    count = show_blank_fields
    count += show_duplicated_fields
    # @logger.debug "# show_detected (Importer) E"
    count
  end

  def detect_replace_key(json, replace_keys)
    json.map do |x|
      new_x = {}
      x.each_key do |key|
        if (new_key = replace_keys[key])
          new_x[new_key] = x[key]
        else
          new_x[key] = x[key]
        end
      end
      new_x
    end
  end

  def cmoplement_key(json, complement_key_value)
    json.map do |x|
      complement_key_value.each do |key, default_value|
        x[key] = default_value unless x[key]
      end
      x
    end
  end
end
