require "json"

class TopImporter
  def initialize(datalist_file_pn, search_file_pn = nil, local_file_pn = nil)
    @logger = LoggerUtils.logger()
    @logger.tagged("#{self.class.name}")

    @logger.debug "TopImporter init search_file_pn=#{search_file_pn}"
    config_pn = ConfigUtils.config_pn
    state_pn = ConfigUtils.state_pn

    @datadir = DatadirUtils.new()

    @datalist_file_pn = datalist_file_pn
    @datalist = DatalistUtils.new(dir_pn: @datadir.output_pn, file_pn: @datalist_file_pn)

    @search_file_pn = search_file_pn if search_file_pn && search_file_pn.exist?
    @local_file_pn = local_file_pn if local_file_pn && local_file_pn.exist?

    @vx = @datalist.parse
    @ks = {}
    obj = JsonUtils.parse(config_pn)
    @logger.debug "TopImporter config_pn=#{config_pn}"
    @logger.debug "obj.class=#{obj.class}"

    @keys = obj["keys"]
    @xkeys = obj["xkeys"]

    make_map

    # @logger.debug "@local_file_pn=#{@local_file_pn}"
    @local_files = JsonUtils.parse(@local_file_pn) if local_file_pn

    @state = JsonUtils.parse(state_pn)
  end

  def get_import_date(key)
    ret = ConfigUtils.default_import_date
    begin
      date_str = @state["import_date"][key]
      ret = Date.parse(date_str)
    rescue StandardError => exc
      @logger.fatal exc.message
    end

    ret
  end

  def make_importer(ext, kind)
    importerkind = "#{kind}#{ext}"
    date = get_import_date(importerkind)
    if ext && !@local_files.nil?
      path = @local_files[importerkind]
      if path.nil?
        msg = "TopImporter#make_importer path is nil importerkind=#{importerkind}"
        p msg
        raise
      end
      make(importerkind, kind, date, path)
    else
      make(importerkind, kind, date)
    end
  end

  def importer_xf(importer, item, year, kind = nil)
    msg = "TopImporter#import_xf importer.class=#{importer.class} item=#{item} year=#{year} kind=#{kind}"
    LoggerUtils.log_debug_p(msg, @logger)

    key = item[1][0].key

    if kind.nil?
      ret = importer.xf(key: key, year: year, mode: :register)
    else
      ret = importer.xf_booklist(key: key, year: year, mode: :register)
    end
    ret
  end

  def execute_importer_xf(importer, item_list, year, kind)
    item_list.map do |item|
      importer_xf(importer, item, year, kind)
    end
  end

  def execute_sub(category, data_keys_hash)
    category_x, ext = category.split("_")
    msg = "execute_sub category_x.class=#{category_x.class}"
    LoggerUtils.log_debug_p(msg, @logger)

    case category_x
    when /reading|kindle|calibre/
      kind = nil
    when "book"
      kind = :xf_booklist
    when "api"
      kind = nil
      msg = "Not implemented Importer for api"
      LoggerUtils.log_debug_p(msg, @logger)
    else
      msg = "Invalid category #{key}"
      LoggerUtils.log_debug_p(msg, @logger)
      raise
    end

    # binding.debugger
    importer = make_importer(ext, category_x)
    return unless importer

    msg = "TopImporter#execute_sub importer.class=#{importer.class}"    
    LoggerUtils.log_debug_p(msg, @logger)
    data_keys_hash.map do |year, item_list|
      msg = "TopImporter#execute_sub year=#{year} #{item_list.class}"
      LoggerUtils.log_debug_p(msg, @logger)
    end

    data_keys_hash.map do |year, item_list|
      msg = "TopImporter#execute_sub year=#{year} item_list.class=#{item_list.class}"
      LoggerUtils.log_debug_p(msg, @logger)
      execute_importer_xf(importer, item_list, year, kind)
    end
  end

  def make_import_data_list(search_file_pn, vx)
    search_item = JsonUtils.parse(search_file_pn)

    @datalist.datax(vx, search_item)
  end

  def execute
    hash = make_import_data_list(@search_file_pn, @vx)

    hash.map do |category, data_keys_hash|
      msg = "TopImporter#execute category=#{category}"
      LoggerUtils.log_debug_p(msg, @logger)
      execute_sub(category, data_keys_hash)
    end
  end

  def make(kind, name, import_date, path = nil)
    msg = "TopImporter#make kind=#{kind} name=#{name} import_date=#{import_date} path=#{path}|"
    LoggerUtils.log_debug_p(msg, @logger)

    case kind
    when "book"
      import = BookImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "bookfile"
      import = BookfileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
    when "bookloose"
      import = BooklooseImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "booktight"
      import = BooktightImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "reading"
      #binding.debugger
      import = ReadingImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "readingfile"
      import = ReadingfileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
    when "kindle"
      import = KindleImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "kindlefile"
      import = KindlefileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
    when "calibre"
      import =CalibreImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "calibrefile"
      import = CalibrefileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
    else
      import = nil
    end
    # binding.debugger unless import
    return import
  end

  def make_map
    @keys.map do |k|
      @ks[k] = k_check_x(k, @vx, 1)
    end
    @ks
  end

  def key_check_x(str, key, index)
    str.split("|")[index] == key
  end

  def k_check_x(key, hs, index)
    hs[:key].keys.select do |k|
      key_check_x(k, key, index)
    end
  end
end
