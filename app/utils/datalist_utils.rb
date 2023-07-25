require 'forwardable'

class DatalistUtils
  attr_reader :file_pn, :out_hash

  class Keylable
    attr_reader :category_index, :label_index, :year_index
    attr_reader :array, :year, :label, :category

    @@category_index = 1
    @@label_index = 4
    @@year_index = 5

    def self.reorder_kind(kind, kindx)
      p "kind=#{kind}"
      p "kindx=#{kindx}"
  
      kind_index = @@category_index
      case kind
      when "api"
        if kindx =~ /\d{4}/
          kindx_index = @@year_index
        else
          kindx_index = @@label_index
        end
      else
        kindx_index = @@year_index
      end
      raise unless kind_index
      raise unless kindx_index
      [kind_index, kindx_index]
    end
  
    def initialize(str)
      @array = str.split('|')
      @year = @array[@@year_index].to_i
      @label = @array[@@label_index]
      @category = @array[@@category_index]
    end
  end

  class Item
    attr_reader :relative_file, :full_path, :src_url, :key

    def self.create(key, src_url, count, dir_pn)
      keylabel = DatalistUtils::Keylable.new(key)

      dirname = keylabel.category
      output_dir_pn = dir_pn + dirname
      output_dir_pn.mkdir unless output_dir_pn.exist?
      out_fname = "#{count}.json"
      output_file_pn = output_dir_pn + out_fname
      full_path = output_file_pn
      #
      relative_file_pn = output_file_pn.relative_path_from(dir_pn)
      #
      Item.new(key, relative_file_pn.to_s, src_url, full_path, keylabel)
      #
      # memo[key] = [relative_file_pn.to_s, src_url, self]
      # get_and_save_page(src_url, output_file_pn)    end
    end

    extend Forwardable
    def_delegators(:@keylabel, :year, :label, :category, :array)

    def initialize(key, relative_file, src_url, full_path, keylabel = nil)
      @key = key
      if keylabel
        @keylabel = keylabel
      else
        @keylabel = DatalistUtils::Keylable.new(key)
      end
      @array = @keylabel.array
      @relative_file = relative_file
      @src_url = src_url

      @full_path = full_path
    end
  end

  def initialize(dir_pn:, file_pn: nil)
    #######################
    @dir_pn = dir_pn
    @out_hash = {}
    @file_pn = file_pn if file_pn && file_pn.exist?
    @file_pn = @dir_pn + "datalist.json" unless @file_pn
    create_need = true
    create_need = false if @file_pn.exist? && @file_pn.size != 0
    make_output_json(@out_hash) if create_need   
  end

  def make_content_of_out_json(hash)
    count = 1
    @out_hash = hash.each_with_object({}) { |item, memo|
      key = item[0]
      src_url = item[1]
      memo[key] = Item.create(key, src_url, count, @dir_pn)
      count += 1
    }
  end

  def parse
    # p "DatalistUtils @file_pn=#{@file_pn}"
    hash = JsonUtils.parse(@file_pn)
    # pp hash
    hash.each_with_object({ key:{}, category: {}, list: [], category_list: [] }){ |xv, memo|
    # p "====----"
    # p "@file_pn=#{@file_on}"
      # p item
      # exit(9)
      # pp "xv=#{xv}"
      key = xv[0]
      relative_file = xv[1][0]
      src_url = xv[1][1]

      # full_path = value.full_path
      # src_url = value.src_url
      path = @dir_pn + relative_file
      item = Item.new( key, relative_file, src_url, path )
      # p memo
      memo[:key] ||= {}
      memo[:key][item.key] = item
      memo[:list] ||= []
      memo[:list] << item
      memo[:category_list] ||= []
      memo[:category_list] << item
      memo[:category] ||= {}
      memo[:category][item.category] ||= {}
      memo[:category][item.category][item.year] = item
    }
  end

  def make_output_json(hash)
    # :relative_file, :src_ur
    new_hash = hash.each_with_object({}){ |obj, memo|
      key = obj[0]
      item = obj[1]
      # exit(0)

      memo[item.key] = [item.relative_file, item.src_url]    
    }
    # pp new_hash
    JsonUtils.output(@file_pn, new_hash)
    # json_str = JSON.generate(new_hash)
    # @file_pn.write(json_str)
  end


  def datax(hash, search_item)
    # pp "datax 1"
    # pp hash.keys
    # p search_item
    new_hash = {}
    search_item.keys.map { |kind|
      # p "kind=#{kind}"
      new_hash[kind] ||= {}
      search_item[kind].map { |kindx|
        kind_index, kindx_index = Keylable.reorder_kind(kind, kindx)
        raise unless hash
        raise unless kind_index
        raise unless kind
        raise unless kindx_index
        raise unless kindx
        # pp "datax 2"
        # pp hash.keys
        new_hash[kind][kindx] = datax_by_item(hash: hash, arg1: [kind_index, kind], arg2: [kindx_index, kindx])
      }
        # pp datax_by_item(hash: hash, arg1: [1, kind, :string])
    }
    new_hash
  end

  def get_number(str)
    if str
      if str =~ /\d{4}/
        str.to_i
      else
        str
      end
    else
      str
    end
  end

  def datax_by_item(hash: , arg1: nil, arg2: nil, arg3: nil)
    num, keyx = arg1
    num2, keyx2 = arg2
    num3, keyx3 = arg3
    keyx2 = get_number(keyx2)
    keyx3 = get_number(keyx3)

    p "keyx=#{keyx}"
    p "keyx2=#{keyx2}"
    p "keyx3=#{keyx3}"
    list = hash[:list].select { |item|
      #p item.category
      #p item.label
      #p item.year
      if keyx2 == ":all" || keyx2 == ":latest" || keyx2 == ""
        item.category == keyx        
      else
        ret = item.category == keyx && item.year == keyx2
        if item.category == "book" && keyx == "book"
          puts "ret=#{ret} item.year=#{item.year} item.year.class=#{item.year.class} keyx2=#{keyx2} keyx2.class=#{keyx2.class}"
        end
        ret
      end
    }

    if keyx2 == ":latest"
      target = list.sort_by{ |a,b|
        if b 
          a.year <=> b.year
        else
          1
        end
      }.last
      [target.key ]
    else
      list.map{|target| target.key }
    end
    # exit 0
  end

  def datax_by_item0(hash: , arg1: nil, arg2: nil, arg3: nil)
    num, keyx = arg1
    num2, keyx2 = arg2
    num3, keyx3 = arg3

    # pp hash.keys
    list = hash[:key].keys.select { |key|
      p "key=#{key}"
      p "keyx=#{keyx}"
      p "keyx2=#{keyx2}"
      p "keyx3=#{keyx3}"
      item = hash[:key][key]
      # p item
      # pp item.keys
      var1 = item.array[num]
      var2 = item.array[num2] if num2
      var3 = item.array[num3] if num3
      if keyx2 == ":all"
        if keyx3 == ":all"
          var1 == keyx
        else
          var1 == keyx && var3 == keyx3
        end
      else
        if keyx3 == ":all"
          var1 == keyx && var2 == keyx2
        else
          var1 == keyx && var2 == keyx2 && var3 == keyx3
        end
      end
    }
    p "===---"
    p list
    exit
  end
end
