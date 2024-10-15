class DetectorImporter
  attr_reader :ignore_blank_keys

  def initialize
    @logger = LoggerUtils.logger
    @logger.tagged("#{self.class.name}")


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
        @values[key][value] += 1
      	ret = true 
      else
        @values[key][value] = 1
      end
    else
      @values[key] = {}
      @values[key][value] = 1
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
    p "#### show_detected S"
    count = show_blank_fields
    count += show_duplicated_fields
    # @logger.debug "# show_detected (Importer) E"
    p "#### show_detected E (count=#{count})"
    count
  end

  def detect_replace_key_sub(hash, replace_keys)
    new_x = {}
    hash.each_key do |key|
      if (new_key = replace_keys[key])
        new_x[new_key] = hash[key]
      else
        new_x[key] = hash[key]
      end
      # p "detector_importer key=#{key} new_key=#{new_key}"
    end
    new_x
  end

  def detect_replace_key_x(hash, replace_keys)
    new_hash = {}
    keys = hash.keys
    keys.each do |k|
      new_hash[k] = detect_replace_key(hash[k], replace_keys)
    end
    new_hash
  end

  def detect_replace_key(hash, replace_keys)
    if hash.instance_of?(Hash)
      # p "detector_importer hash=#{} Hash"
      detect_replace_key_sub(hash, replace_keys)
    else
      if json.instance_of?(String)
        p "detector_importer hash=#{hash} String"
        raise
      elsif hash.instance_of?(Array)
        p "detector_importer hash=#{hash} Array"
        raise
        hash.map do |x|
          detect_replace_key(x, replace_keys)
        end
      else
        raise
      end
    end
  end

  def complement_key_x(hash, complement_key_value)
    new_hash = {}
    hash.each_key do |k|
      new_hash[k] = complement_key(hash[k], complement_key_value)
    end
    new_hash
  end

  def complement_key(hash, complement_key_value)
    # p "detector_importer#complement_key hash.class=#{hash.class}"
    # p "hash=#{hash}"
    complement_key_value.each do |complement_key, default_value|
      hash[complement_key] = default_value unless hash[complement_key]
    end
    hash
  end
end
