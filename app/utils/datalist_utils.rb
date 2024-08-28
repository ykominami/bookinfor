require "forwardable"

class DatalistUtils
  attr_reader :file_pn, :out_hash

  class Keylable
    attr_reader :array, :year, :label, :category

    # category_index = 1
    # label_index = 4
    # year_index = 5
    CATEGORY_INDEX = 1
    LABEL_INDEX = 4
    YEAR_INDEX = 5

    def self.reorder_kind(kind, kindx)
      kind_index = CATEGORY_INDEX
      case kind
      when "api"
        if kindx =~ /\d{4}/
          kindx_index = YEAR_INDEX
        else
          kindx_index = LABEL_INDEX
        end
      else
        kindx_index = YEAR_INDEX
      end
      raise unless kind_index
      raise unless kindx_index

      [kind_index, kindx_index]
    end

    def self.year_index
      @year_index
    end

    def initialize(str)
      @array = str.split("|")
      @year = @array[YEAR_INDEX].to_i
      @label = @array[LABEL_INDEX]
      @category = @array[CATEGORY_INDEX]
      @logger = LoggerUtils.logger
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
      relative_file_pn = output_file_pn.relative_path_from(dir_pn)
      Item.new(key, relative_file_pn.to_s, src_url, full_path, keylabel)
    end

    extend Forwardable
    def_delegators(:@keylabel, :year, :label, :category, :array)

    def initialize(key, relative_file, src_url, full_path, keylabel = nil)
      @key = key
      @keylabel = keylabel || DatalistUtils::Keylable.new(key)
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
    @logger = LoggerUtils.logger

    @dir_pn = dir_pn
    @out_hash = {}
    @file_pn = file_pn if file_pn && file_pn.exist?
    @file_pn ||= @dir_pn + ConfigUtils.datalist_json_filename
    @logger = LoggerUtils.logger
  end

  def ensure_datalist_json(out_hash)
    create_need = true
    create_need = false if @file_pn.exist? && @file_pn.size != 0
    make_output_json(out_hash) if create_need
  end

  def parse
    # @logger.debug "DatalistUtils @file_pn=#{@file_pn}"
    hash = JsonUtils.parse(@file_pn)
    parse_datalist_content(hash)
  end

  def parse_datalist_content(hash)
    hash.each_with_object({ key: {}, category: {}, list: [], category_list: [] }) do |xv, memo|
      key = xv[0]
      relative_file = xv[1][0]
      src_url = xv[1][1]
      if relative_file == ""
        item = Item.create(key, src_url, @dir_pn)
      else
        full_path = @dir_pn + relative_file
        item = Item.new(key, relative_file, src_url, full_path)
        # @logger.debug "Datalist relative_file=#{relative_file}"
        # @logger.debug "src_url=#{src_url}"
        # @logger.debug "full_path=#{full_path}"
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
    end
  end

  def make_output_json(hash)
    new_hash = hash.each_with_object({}) do |obj, memo|
      obj[0]
      item = obj[1]
      # exit(0)

      tmp = [item.relative_file, item.src_url]
      memo[item.key] = tmp
    end
    JsonUtils.output(@file_pn, new_hash)
  end

  def datax(hash, search_item)
    new_hash = {}
    return nil unless search_item

    search_item.keys.map do |kind|
      new_hash[kind] ||= {}
      search_item[kind].map do |kindx|
        kind_index, kindx_index = Keylable.reorder_kind(kind, kindx)
        raise unless hash
        raise unless kind_index
        raise unless kind
        raise unless kindx_index
        raise unless kindx

        new_hash[kind][kindx] = datax_by_item(hash: hash, arg1: [kind_index, kind], arg2: [kindx_index, kindx])
      end
    end
    new_hash.each_key do |key|
      new_hash[key].each_key do |key2|
        @logger.debug "new_hash[#{key}][#{key2}]=#{new_hash[key][key2]}"
      end
    end
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

  def datax_by_item(hash:, arg1: nil, arg2: nil, arg3: nil)
    _, keyx = arg1
    _, keyx2 = arg2
    _, keyx3 = arg3
    keyx, = keyx.split("_")

    keyx2 = get_number(keyx2)
    get_number(keyx3)

    list = hash[:list].select do |item|
      result = if [":all", ":latest", ""].include?(keyx2)
                 item.category == keyx
               else
                 @logger.debug "keyx2=#{keyx2}|#{keyx2.class}" if item.category == keyx
                 ret = item.category == keyx && item.year == keyx2
                 @logger.debug "ret=#{ret} item.year=#{item.year} item.year.class=#{item.year.class} keyx2=#{keyx2} keyx2.class=#{keyx2.class}" if item.category == "book" && keyx == "book"
                 ret
               end
      result
    end

    ret_list = []
    if keyx2 == ":latest"
      target = list.sort_by do |a, b|
        if b
          a.year <=> b.year
        else
          1
        end
      end.last
      ret_list = if target
                   [target.key]
                 else
	           []
                 end
    else
      ret_list = list.map { |target| target.key }
    end

    ret_list
  end
end
