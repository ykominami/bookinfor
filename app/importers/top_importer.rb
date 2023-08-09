require "json"

class TopImporter
  def initialize(datalist_file_pn, search_file_pn = nil)
    config_pn = ConfigUtils.config_pn

    @datadir = DatadirUtils.new()

    @datalist_file_pn = datalist_file_pn
    @datalist = DatalistUtils.new(dir_pn: @datadir.output_pn, file_pn: @datalist_file_pn)

    @search_file_pn = search_file_pn if search_file_pn && search_file_pn.exist?

    @vx = @datalist.parse
    @ks = {}
    obj = JsonUtils.parse(config_pn)
    @keys = obj["keys"]
    @xkeys = obj["xkeys"]
    make_map
  end

  def execute()
    search_item = JsonUtils.parse(@search_file_pn)
    list = @datalist.datax(@vx, search_item)

    list.map { |key, value|
      value.map { |key2, value2|
        importer = make(key)
        case key
        when "reading"
          value2.map { |key|
            importer.xf_reading(key, :register)
            # p "Readinglist.all.size=#{Readinglist.all.size}"
          }
        when "kindle"
          value2.map { |key|
            importer.xf_kindle(key, :register)
            # p "Kindlelist.all.size=#{Kindlelist.all.size}"
          }
        when "calibre"
          value2.map { |key|
            importer.xf_calibre(key, :register)
            # p "Calibrelist.all.size=#{Calibrelist.all.size}"
          }
        when "book"
          # p "book key2=#{key2}"
          # p "value2=#{value2}"
          value2.map { |key|
            # p "book key=#{key}"
            importer.xf_booklist(key: key, mode: :register)
            # p "Booklist.all.size=#{Booklist.all.size}"
          }
        when "api"
          puts "Not implemented Importer for api"
        else
          puts "Invalid category #{key}"
        end
      }
    }
  end

  def book_x()
    years = %W(2013 2014 2015 2016 2017 2018 2019 2020 2021 2022 2023)
    # year = 2020
    #year = 2021
    years.each do |year|
      p "# year=#{year}"
      importer.xf_booklist(year: year, mode: :register)
    end
  end

  def make(name)
    # p "ImporterTop.make name=#{name}"
    case name
    when "book"
      return BookImporter.new(@vx, @xkeys[name], @ks)
    when "bookloose"
      return BooklooseImporter.new(@vx, @xkeys[name], @ks)
    when "booktight"
      return BooktightImporter.new(@vx, @xkeys[name], @ks)
    when "reading"
      return ReadingImporter.new(@vx, @xkeys[name], @ks)
    when "kindle"
      return KindleImporter.new(@vx, @xkeys[name], @ks)
    when "calibre"
      return CalibreImporter.new(@vx, @xkeys[name], @ks)
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
    # true
  end

  def k_check_x(key, hs, index)
    # p hs.keys
    hs[:key].keys.select { |k|
      key_check_x(k, key, index)
    }
  end
end
