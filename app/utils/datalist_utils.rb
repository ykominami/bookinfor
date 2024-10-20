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

    attr_reader :key, :array
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
    hash.each_with_object({ key: {}, category: {}, list: [], category_list: [] }) do |xv,memo|
      key = xv[0]

      relative_file = xv[1][0]
      src_url = xv[1][1]
      if relative_file == ""
        item = Item.create(key, src_url, @dir_pn)
      else
        full_path = @dir_pn + relative_file
        item = Item.new(key, relative_file, src_url, full_path)
      end

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

      tmp = [item.relative_file, item.src_url]
      memo[item.key] = tmp
    end
    JsonUtils.output(@file_pn, new_hash)
  end

  def datax(hash, search_item)
    # binding.debugger

    new_hash = {}
    return nil unless hash
    return nil unless search_item

    search_item.each_key do |category|
      new_hash[category] ||= {}
      search_item[category].map do |year|
        new_hash[category][year] ||= {}
        # categoryとyearの組み合わせでソートされたリストを割り当てしなおす
        new_hash[category][year][:list] = sorted_by_category_and_year(list: hash[:list], category: category, year: year)
      end
    end

    new_hash
  end

  # 4桁の数字部分を含んでいる場合は、その数字部分を数値として取り出す
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

  def sorted_by_category_and_year(list:, category: nil, year: nil)
    category, = category.split("_")
    # 数字部分を含んでいる場合は、その数字部分を取り出す
    year = get_number(year)

    # 指定categoryに一致するものを取り出す(yearが:allの場合は全ての年、:latestの場合は最新の年のみが指定されているとして扱う）
    # または、指定categoryと指定yearに一致するものを取り出す

    # 以下で、:listはRubyのシンボルである。":all"は":latest"はシンボルではなく、文字列として扱われる
    new_list = list.select do |item|
      if [":all", ":latest", ""].include?(year)
        item.category == category
      else
        item.category == category && item.year == year
      end
    end

    ret_list = []
    # :latestの場合は最新の年のみを取り出す
    if year == ":latest"
      target = new_list.sort_by do |a, b|
                              if b
                                a.year <=> b.year
                              else
                                1
                              end
                            end.last
      # 配列からlastメソッドで取り出したので、targetは配列ではない
      # そのため、targetがnilでない場合は、配列に変換して返す
      ret_list = if target
                   [target]
                 else
	                []
                 end
    else
      ret_list = new_list
    end

    ret_list
  end
end
