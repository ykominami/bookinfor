require "json"

class TopImporter
  def initialize(datalist_file_pn, search_file_pn = nil, local_file_pn = nil)
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

    # p "@local_file_pn=#{@local_file_pn}"
    @local_files = JsonUtils.parse(@local_file_pn) if local_file_pn

    @state = JsonUtils.parse(state_pn)
  end

  def get_import_date(key)
    date_str = @state["import_date"][key]
    Date.parse(date_str)
  end

  def execute()
    search_item = JsonUtils.parse(@search_file_pn)
    # exit
    list = @datalist.datax(@vx, search_item)

    list.map { |importer_kind, value|
      importer_kind_x, ext = importer_kind.split("_")

      value.map { |key2, value2|
        # puts "importer_kind_x=#{importer_kind_x}"
        if ext
          importerkind = "#{importer_kind_x}#{ext}"
          path = @local_files[importer_kind]
          date = get_import_date(importer_kind_x)
          importer = make(importerkind, importer_kind_x, date, path)
        else
          date = get_import_date(importer_kind)
          importer = make(importer_kind, importer_kind, date)
        end

        case importer_kind_x
        when "reading"
          value2.map { |data_key|
            # importer.xf_reading(data_key, :register)
            importer.xf(data_key, :register)
          }
        when "kindle"
          value2.map { |data_key|
            # importer.xf_kindle(data_key, :register)
            importer.xf(data_key, :register)
          }
        when "calibre"
          value2.map { |data_key|
            # importer.xf_calibre(data_key, :register)
            importer.xf(data_key, :register)
          }
        when "book"
          value2.map { |data_key|
            importer.xf_booklist(key: data_key, mode: :register)
          }
        when "api"
          puts "Not implemented Importer for api"
        else
          puts "Invalid category #{key}"
          raise
        end
      }
    }
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
    @keys.map { |k|
      @ks[k] = k_check_x(k, @vx, 1)
    }
    @ks
  end

  def key_check_x(str, key, index)
    str.split("|")[index] == key
  end

  def k_check_x(key, hs, index)
    hs[:key].keys.select { |k|
      key_check_x(k, key, index)
    }
  end
end
