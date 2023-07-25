class BookImporter < BaseImporter
  class BookDetectorImporter < DetectorImporter
    def show_detected
      #show_blank_fields
      #show_duplicated_fields
      puts "# show_detected (ImporterBook) S"
  
      count = super()
      count += show_duplicated_field("title")
      puts "# show_detected (ImporterBook) E"
      count
    end

    def detect(target, reg_hash)
      ret = reg_hash.find { |key, reg_array|
        retb = reg_array.find { |reg|
          word = target[key]
          reta = reg.match(word)
          reta != nil
        }
        retb != nil
      }
      ret
    end
  
    def detect_ignore_items(target, reg_hash)
      detect(target, reg_hash) != nil
    end
  
  end  

  def initialize(vx, keys, ks)
    super(vx, keys, ks)
    @detector = BookDetectorImporter.new()
    @name = "book"
    @ar_klass = Booklist
  end

  def xf_supplement(target, x, base_number = nil)
    if x["totalid"]
      x["totalID"] = x["totalid"]
      x.delete("totalid")
    end
    if x["totalID"]
      x["totalID"] = x["xid"].to_i + base_number
      find_duplicated_field_value(target, "totalID", x)
    end
    x
  end

  def make_reg_list(hash)
    reg_hash = {}
    hash.each do |field, array|
      array.each do |str|
        escaped_str = Regexp.escape(str)
        reg_hash[field] ||= []
        reg_hash[field] << Regexp.new(escaped_str)
      end
    end
    reg_hash
  end
=begin
  def xf(year, mode = :none)
    data_array = []

    xf_begin(year)
    base_number = year * 1000
    reg_hash = make_reg_list(@ignore_field_value_hash)
    @json.select { |x|
      found = @detector.detect_ignore_items(x, reg_hash)
      if found
        next
      end
      @delkeys.map { |k| x.delete(k) }
      x.delete("")

      x = xf_supplement(x, x, base_number)

      @detector.detect_blank(x, x)
      data_array << x
    }
    count = @detector.show_detected

    @ar_klass.insert_all(data_array) if mode == :register && count == 0
  end
=end
  def xf_booklist(year: nil, key: nil, mode: :register)
    puts "book 0"
    @detector = DetectorImporter.new()
    @ignore_field_list = []
    @ignore_field_value_hash = { "bookstore" => ["アマゾン(Kindle"] }

    data_array = []

    @detector.blank_field_init()
    @detector.duplicated_field_init()

    # pp @vx[:category][@name] 

    if key != nil
      if year != nil
        puts "book return 2"
        return
      else
        item = @vx[:key][key]
        year = item.year
      end
    else
      if year != nil
        item = @vx[:category][@name][year]
      else
        puts "book return 3"
        return
      end
    end

    if @vx[:category] == nil ||
       @vx[:category][@name] == nil || 
       @vx[:category][@name][year] == nil
       puts "book return 1"
      return
    end

    # year = key.split("|")[5].to_i
    base_number = year * 1000

    # path = @vx[:key][key].relative_file
    # full_path = @vx[:key][key].full_file
    # path = item.relative_file
    path = item.full_path
    puts "path=#{path}"
    # exit(100)
    @detector.register_ignore_blank_field("isbn")
    @detector.register_ignore_blank_field("series")
    @detector.register_ignore_blank_field("comments")
    @detector.register_ignore_blank_field("rating")
    @detector.register_ignore_blank_field("identifiers")

    json = JsonUtils.parse(path)

    json.map { |x|
      #x = json[0]
      @delkeys.map { |k| x.delete(k) }
      if x["totalid"]
        x["totalID"] = x["totalid"]
        x.delete("totalid")
      end
      x.delete("")
      if x["totalID"]
        x["totalID"] = x["xid"].to_i + base_number
      end
      if x["xid"]
        x["xid"] = x["xid"].to_i + base_number
      end
      @detector.detect_blank(x, x)

      data_array << x
    }
    count = @detector.show_detected
    puts "count=#{count}"
    puts "mode=#{mode}"
    pp data_array.size
    if mode == :register && count == 0
      @ar_klass.insert_all(data_array) 
      puts @ar_klass
      puts "END=="
    end
  end
end
