class DetectorImporter
  def initialize()
    @_errors = {}
    @_errors[:target] ||= {}

    duplicated_field_init()
    blank_field_init()
  end

  def duplicated_field_init()
    @values ||= {}
    @dup_fields ||= {}
    @dup_keys ||= {}
    @_errors[:duplicated] ||= []
  end

  def blank_field_init()
    @blank_keys ||= {}
    @ignore_blank_keys ||= []
    @_errors[:blank] ||= []
  end

  def register_ignore_blank_field(name)
    @ignore_blank_keys << name
  end

  def detect_blank(target, x)
    # puts "# show_blank S"
    ret = find_blank(x)
    if ret.size > 0
      ret.keys.map { |key|
        next if @ignore_blank_keys.index(key)
        puts "blank key=#{key}"
        @_errors[:target][target] ||= []
        @_errors[:target][target] << [:blank, key]
        @_errors[:blank] << [target, "key=#{key}"]
        count_up(target, @blank_keys, key)
      }
    end
    # puts "# show_blank E"
  end

  def find_blank(hash)
    hash.select { |k, v|
      v == nil || v == ""
    }
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
      if @dup_fields[key].size == 0
        @dup_fields[key] << @values[key][value]
      end
      @dup_fields[key] << fields

      @_errors[:target][target] ||= []
      @_errors[:target][target] << [:duplicated, key]
      @_errors[:duplicated] << [target, key]
      count_up(target, @dup_keys, key, value)
    end
    ret
  end

  def show_blank_fields
    pp "==== blank"
    pp @blank_keys.size
    pp @blank_keys[0]
    pp @_errors[:blank][0]
    pp "===="

    @blank_keys.size
  end

  def show_duplicated_fields
    pp "==== duplicated"
    pp @dup_keys.size
    pp @dup_keys[0]
    pp @_errors[:duplicated][0]
    pp "===="

    @dup_keys.size
  end

  def show_duplicated_field(key)
    pp "=== duplicated key=#{key}"
    pp @dup_fields[key]

    @dup_fields.size
  end

  def show_detected
    puts "# show_detected (Importer) S"
    count = show_blank_fields
    count += show_duplicated_fields
    puts "# show_detected (Importer) E"
    count
  end

  def detect_replace_key(json, replace_keys)
    new_json = json.map { |x|
      new_x = {}
      x.keys.each do |key|
        if (new_key = replace_keys[key])
          new_x[new_key] = x[key]
        else
          new_x[key] = x[key]
        end
      end
      new_x
    }
  end

  def cmoplement_key(json, complement_key_value)
    new_json = json.map { |x|
      complement_key_value.each do |key, default_value|
        x[key] = default_value unless x[key]
      end
      x
    }
  end
end
