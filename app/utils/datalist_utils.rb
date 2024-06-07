require "forwardable"

class DatalistUtils
  attr_reader :file_pn, :out_hash

  class Keylable
    attr_reader :category_index, :label_index, :year_index
    attr_reader :array, :year, :label, :category

    @@category_index = 1
    @@label_index = 4
    @@year_index = 5

    def self.reorder_kind(kind, kindx)
      # p "kind=#{kind}"
      # p "kindx=#{kindx}"

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
      @array = str.split("|")
      @year = @array[@@year_index].to_i
      @label = @array[@@label_index]
      @category = @array[@@category_index]
    end

    def to_json(it)
      JSON.dump({
        array: @array,
        year: @year,
        lable: @label,
        category: @category,
      })
    end
  end

  class Item
    attr_reader :relative_file, :full_path, :src_url, :key

    def self.create(key, src_url, dir_pn)
      keylabel = DatalistUtils::Keylable.new(key)
      dirname = keylabel.category
      output_dir_pn = dir_pn + dirname
      output_dir_pn.mkdir unless output_dir_pn.exist?
      if keylabel.category == "api"
        out_fname = "#{keylabel.label}-#{keylabel.year}.json"
      else
        out_fname = "#{keylabel.year}.json"
      end
      output_file_pn = output_dir_pn + out_fname
      full_path = output_file_pn
      #
      relative_file_pn = output_file_pn.relative_path_from(dir_pn)
      #
      Item.new(key, relative_file_pn.to_s, src_url, full_path, keylabel)
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

    def to_json(it)
      JSON.dump({
        key: @key,
        keylabel: @keylabel,
        array: @array,
        relative_file: @relative_file,
        src_url: @src_url,
        full_path: @full_path,
      })
    end
  end

  def initialize(dir_pn:, file_pn: nil)
    @dir_pn = dir_pn
    @out_hash = {}
    @file_pn = file_pn if file_pn && file_pn.exist?
    @file_pn = @dir_pn + ConfigUtils.datalist_json_filename unless @file_pn
  end

  def ensure_datalist_json(out_hash)
    create_need = true
    create_need = false if @file_pn.exist? && @file_pn.size != 0
    make_output_json(out_hash) if create_need
  end

  def parse
    # p "DatalistUtils @file_pn=#{@file_pn}"
    hash = JsonUtils.parse(@file_pn)
    parse_datalist_content(hash)
  end

  def parse_datalist_content(hash)
    hash.each_with_object({ key: {}, category: {}, list: [], category_list: [] }) { |xv, memo|
      key = xv[0]
      relative_file = xv[1][0]
      src_url = xv[1][1]
      if relative_file != ""
        full_path = @dir_pn + relative_file
        item = Item.new(key, relative_file, src_url, full_path)
        # p "Datalist relative_file=#{relative_file}"
        # p "src_url=#{src_url}"
        # p "full_path=#{full_path}"
      else
        item = Item.create(key, src_url, @dir_pn)
      end
      # path = @dir_pn + relative_file

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
    # puts "############   DatalistUtils#make_output_json"
    # :relative_file, :src_ur
    # pp "hash.keys=#{hash.keys}"
    new_hash = hash.each_with_object({}) { |obj, memo|
      key = obj[0]
      item = obj[1]
      # exit(0)

      tmp = [item.relative_file, item.src_url]
      memo[item.key] = tmp
    }
    # pp new_hash
    # puts "new_hash=#{new_hash}"
    JsonUtils.output(@file_pn, new_hash)
    # puts "@file_on=#{@file_pn}"
    # json_str = JSON.generate(new_hash)
    # @file_pn.write(json_str)
  end

  def datax(hash, search_item)
    # puts "DatalistUtils#datax hash=#{hash} search_item=#{search_item}"
    # puts "DatalistUtils#datax hash.keys=#{hash.keys} search_item.keys=#{search_item.keys}"
    # puts "search_item.class=#{search_item.class}"
    new_hash = {}
    if search_item
      # puts "datax 1"
      search_item.keys.map { |kind|
        # puts "datax 2 kind=#{kind}"
        # p "datax kind=#{kind}"
        new_hash[kind] ||= {}
        search_item[kind].map { |kindx|
          # puts "datax: kindx=#{kindx}"
          kind_index, kindx_index = Keylable.reorder_kind(kind, kindx)
          # puts "datax: kind_index=#{kind_index} kindx_index=#{kindx_index}"
          raise unless hash
          raise unless kind_index
          raise unless kind
          raise unless kindx_index
          raise unless kindx
          new_hash[kind][kindx] = datax_by_item(hash: hash, arg1: [kind_index, kind], arg2: [kindx_index, kindx])
          # puts "new_hash[#{kind}][#{kindx}]=#{new_hash[kind][kindx]}"
        }
      }
      # puts "new_hash.keys=#{new_hash.keys}"
      new_hash.keys.each do |key|
        # puts "key=#{key}"
        # puts "new_hash[key].class=#{new_hash[key].class}"
        # puts "new_hash[key].keys=#{new_hash[key].keys}"
        new_hash[key].keys.each do |key2|
          # puts "new_hash[#{key}][#{key2}]=#{new_hash[key][key2]}"
        end
      end
      new_hash
    else
      nil
    end
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

  def datax_by_item(hash:, arg1: nil, arg2: nil, arg3: nil)
    num, keyx = arg1
    num2, keyx2 = arg2
    num3, keyx3 = arg3
    keyx, ext = keyx.split("_")

    # puts "datax_by_item ==== S"
    # puts "num=#{num} keyx=#{keyx}"
    # puts "num2=#{num2} keyx2=#{keyx2}"
    # puts "num3=#{num3} keyx3=#{keyx3}"
    # puts "keyx=#{keyx} ext=#{ext}"

    # p "keyx=#{keyx}"
    # p "keyx2=#{keyx2}"
    keyx2 = get_number(keyx2)
    keyx3 = get_number(keyx3)
    # puts "keyx2=#{keyx2} keyx3=#{keyx3}"

    # p "keyx=#{keyx}"
    # p "keyx2=#{keyx2}"
    # p "keyx3=#{keyx3}"
    # pp hash
    list = hash[:list].select { |item|
      # list = hash.select { |item|
      result = if keyx2 == ":all" || keyx2 == ":latest" || keyx2 == ""
        item.category == keyx
      else
        if item.category == keyx
          # p "item.category=#{item.category}"
          # p "item.ywer=#{item.year}|#{item.year.class}"
          # p "keyx2=#{keyx2}|#{keyx2.class}"
        end
        ret = item.category == keyx && item.year == keyx2
        if item.category == "book" && keyx == "book"
          # puts "ret=#{ret} item.year=#{item.year} item.year.class=#{item.year.class} keyx2=#{keyx2} keyx2.class=#{keyx2.class}"
        end
        ret
      end
      result
    }
    # puts "list=#{list}"

    ret_list = []
    if keyx2 == ":latest"
      target = list.sort_by { |a, b|
        if b
          a.year <=> b.year
        else
          1
        end
      }.last
      ret_list = [target.key]
    else
      ret_list = list.map { |target| target.key }
    end
    # puts "ret_list=#{ret_list}"
    # puts "datax_by_item ==== E"

    ret_list
  end
end
