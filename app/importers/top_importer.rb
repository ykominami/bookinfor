require "json"

class TopImporter
  def initialize(datalist_file_pn, search_file_pn = nil, local_file_pn = nil)
    @logger = LoggerUtils.logger()

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

  def execute
    search_item = JsonUtils.parse(@search_file_pn)
    # exit
    list = @datalist.datax(@vx, search_item)

    list.map do |importer_kind, value|
      importer_kind_x, ext = importer_kind.split("_")

      value.map do |_key2, value2|
        # @logger.debug "importer_kind_x=#{importer_kind_x}"
        if ext
          importerkind = "#{importer_kind_x}#{ext}"
          path = @local_files[importer_kind]
          date = get_import_date(importer_kind_x)
          importer = make(importerkind, importer_kind_x, date, path)
        else
          date = get_import_date(importer_kind)
          importer = make(importer_kind, importer_kind, date)
        end

        # raise

        case importer_kind_x
        when "reading" | "kindle" | "calibre"
          value2.map do |data_key|
            # importer.xf_reading(data_key, :register)
            importer.xf(data_key, :register)
          end
        when "book"
          # raise
          value2.map do |data_key|
            importer.xf_booklist(key: data_key, mode: :register)
          end
        when "api"
          @logger.debug "Not implemented Importer for api"
        else
          @logger.debug "Invalid category #{key}"
          raise
        end
      end
    end
  end

  def make(kind, name, import_date, path = nil)
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
