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
    p "importer_xf msg=#{msg}"
    LoggerUtils.log_debug_p(msg, @logger)

    key = item[1][0].key

    if kind.nil?
      p "2 importer_xf importer.class=#{importer.class} key=#{key} year=#{year} mode=:register"
      importer.xf(key: key, year: year, mode: :register)
    else
      p "3importer_xf key=#{key} year=#{year} mode=:register"
      importer.xf_booklist(key: key, year: year, mode: :register)
    end
  end

  def execute_importer_xf(importer, item_list, year, kind)
    item_list.map do |item|
      p "execute_importer_xf item=#{item}"
      importer_xf(importer, item, year, kind)
    end
  end

  def execute_sub(category, data_keys_hash)
    category_x, ext = category.split("_")
    msg = "execute_sub category_x.class=#{category_x.class}"
    p "1 msg=#{msg}"
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
    p "2 msg=#{msg}"

    # binding.debugger
    importer = make_importer(ext, category_x)
    p "importer=#{importer}"
    return unless importer

    msg = "TopImporter#execute_sub importer.class=#{importer.class}"
    p "3 msg=#{msg}"
    LoggerUtils.log_debug_p(msg, @logger)
    data_keys_hash.map do |year, item_list|
      msg = "TopImporter#execute_sub year=#{year} #{item_list.class}"
      p "4 msg=#{msg}"
      LoggerUtils.log_debug_p(msg, @logger)
    end

    data_keys_hash.map do |year, item_list|
      msg = "TopImporter#execute_sub year=#{year} item_list.class=#{item_list.class}"
      p "5 msg=#{msg}"
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
    # p hash
    p "6 hash.keys=#{hash.keys}"
    hash.map do |category, data_keys_hash|
      msg = "TopImporter#execute category=#{category}"
      p msg
      LoggerUtils.log_debug_p(msg, @logger)
      execute_sub(category, data_keys_hash)
      p "execute END category=#{category}"
    end
  end

  def make(kind, name, import_date, path = nil)
    msg = "TopImporter#make kind=#{kind} name=#{name} import_date=#{import_date} path=#{path}|"
    LoggerUtils.log_debug_p(msg, @logger)

    import = case kind
             when "book"
               BookImporter.new(@vx, @xkeys[name], @ks, import_date)
             when "bookfile"
               BookfileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
             when "bookloose"
               BooklooseImporter.new(@vx, @xkeys[name], @ks, import_date)
             when "booktight"
               BooktightImporter.new(@vx, @xkeys[name], @ks, import_date)
             when "reading"
               # binding.debugger
               ReadingImporter.new(@vx, @xkeys[name], @ks, import_date)
             when "readingfile"
               ReadingfileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
             when "kindle"
               KindleImporter.new(@vx, @xkeys[name], @ks, import_date)
             when "kindlefile"
               KindlefileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
             when "calibre"
               CalibreImporter.new(@vx, @xkeys[name], @ks, import_date)
             when "calibrefile"
               CalibrefileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
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

  def key_check_x?(str, key, index)
    str.split("|")[index] == key
  end

  def k_check_x(key, hs, index)
    hs[:key].keys.select do |k|
      key_check_x?(k, key, index)
    end
  end
end
