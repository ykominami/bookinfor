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
    rescue StandardError => exception
      @logger.fatal exception.message
    end

    ret
  end

  def make_importer(ext, kind, name)
    importerkind = "#{kind}#{ext}"
    date = get_import_date(importerkind)
    if ext
      path = @local_files[importerkind]
      # p "top_importer#make_importer 1 importerkind=#{importerkind} date=#{date} path=#{path}"
      make(importerkind, kind, date, path)
    else
      # p "top_importer#make_importer 2 importerkind=#{importerkind} date=#{date}"
      make(importerkind, kind, date)
    end
  end

  def importer_xf(importer, data_key, importer_kind = nil)
    @logger.debug "1 Top_importer#import_xf data_key=#{data_key}"
    # p "1 Top_importer#import_xf data_key=#{data_key}"
    if importer_kind.nil?
      p "2 Top_importer#import_xf importer.class=#{importer.class} data_key=#{data_key}"
      ret = importer.xf(data_key, :register)
    else
      p "3 Top_importer#import_xf importer.class=#{importer.class} data_key=#{data_key}"
      ret = importer.xf_booklist(key: data_key, mode: :register)
    end
    ret
  end

  def execute
    p "=============== TopImporter#execute S"
    search_item = JsonUtils.parse(@search_file_pn)
    # exit
    list = @datalist.datax(@vx, search_item)

    list.map do |importer_kind, data_keys_hash|
      importer_kind_x, ext = importer_kind.split("_")
      @logger.debug  "execute importer_kind_x=#{importer_kind_x}"

      data_keys_hash.map do |_key2, data_keys|
        # @logger.debug "importer_kind_x=#{importer_kind_x}"
        importer = make_importer(ext, importer_kind_x, data_keys)
        # p "############################ top_importer#execute importer.class=#{importer.class}"

        case importer_kind_x
        when /reading|kindle|calibre/
          data_keys.map do |data_key|
            importer_xf(importer, data_key)
          end
        when "book"
          # raise
          data_keys.map do |data_key|
            importer_xf(importer, data_key, :xf_booklist)
          end
        when "api"
          @logger.debug "Not implemented Importer for api"
          # p "Not implemented Importer for api"
        else
          @logger.debug "Invalid category #{key}"
          raise
        end
      end
    end
    p "=============== TopImporter#execute E"
  end

  def make(kind, name, import_date, path = nil)
    @logger.debug "TopImporter#make kind=#{kind} name=#{name} import_date=#{import_date} path=#{path}"
    case kind
    when "book"
      return BookImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "bookfile"
      return BookfileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
    when "bookloose"
      return BooklooseImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "booktight"
      return BooktightImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "reading"
      return ReadingImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "readingfile"
      return ReadingfileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
    when "kindle"
      return KindleImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "kindlefile"
      return KindlefileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
    when "calibre"
      return CalibreImporter.new(@vx, @xkeys[name], @ks, import_date)
    when "calibrefile"
      return CalibrefileImporter.new(@vx, @xkeys[name], @ks, import_date, path)
    else
      return nil
    end
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
