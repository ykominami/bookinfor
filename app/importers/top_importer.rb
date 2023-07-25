require 'json'

class TopImporter
  def initialize(datalist_file_pn, search_file_pn = nil)
    config_pn = Rails.root + "config" + "importers" + "config.json"

    @datadir = DatadirUtils.new()

    @datalist_file_pn = datalist_file_pn
    @datalist = DatalistUtils.new(dir_pn: @datadir.output_pn, file_pn: @datalist_file_pn)

    @search_file_pn = search_file_pn if search_file_pn && search_file_pn.exist?

    @vx = @datalist.parse
    @ks = {}
    # init
    # @keys = %W(calibre api book reading kindle)
    # JsonUtils.output( config_pn ,  {keys: @keys, xkeys: @xkeys } )
    obj = JsonUtils.parse( config_pn )
    p obj
    @keys = obj["keys"]
    @xkeys = obj["xkeys"]
    pp @xkeys["calibre"]
    make_map
  end

  def execute()
    search_item = JsonUtils.parse(@search_file_pn)
    list = @datalist.datax(@vx, search_item)

    list.map{ |key, value|
      value.map{ |key2, value2|
        # puts "# #{key}"
        # puts "# #{key2}"
        # puts "# #{value2}"
        importer = make(key)
        case key
        when "reading"
          value2.map{ |key| 
            importer.xf_reading(key, :register)
            p "Readinglist.all.size=#{Readinglist.all.size}"
          }
        when "kindle"
          value2.map{ |key| 
            importer.xf_kindle(key, :register)
            p "Kindlelist.all.size=#{Kindlelist.all.size}"
          }
        when "calibre"
          value2.map{ |key| 
            importer.xf_calibre(key, :register)
            p "Calibrelist.all.size=#{Calibrelist.all.size}"
          }
        when "book"
          p "book key2=#{key2}"
          p "value2=#{value2}"
          value2.map{ |key| 
            p "book key=#{key}"
            importer.xf_booklist(key: key, mode: :register)
            p "Booklist.all.size=#{Booklist.all.size}"
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
=begin
  def init
    @keys = %W(calibre api book reading kindle)
    @xkeys = {
      calibre: {
        valid: %W[],
        #        remove: %W[identifiers rating cover publisher formats tags series size comments]
        remove: %W[cover id],
        not_duplicated: %W[],
        not_blank: %W[],
      },
      kindle: {
        valid: %W[],
        remove: %W[amazon_link],
        not_duplicated: %W[],
        not_blank: %W[],
      },
      reading: {
        valid: %W[register_date, date, title, status, shape, isbn],
        remove: %W[],
        not_duplicated: %W[],
        not_blank: %W[],
      },
      book: {
        valid: %W[
          totalID
          xid
          purchase_date
          bookstore
          title
          asin
          read_status
          shape
          category
        ],
        remove: %W[
          empty1
          empty2
          empty3
          any1
          any2
          missing
          any3
          category_uniq
          categry_sort
          category_value
        ],
        not_duplicated: %W[],
        not_blank: %W[],
      },
      bookloose: {
        valid: %W[
          totalID
          xid
          purchase_date
          bookstore
          title
          asin
          read_status
          shape
          category
        ],
        remove: %W[
          empty1
          empty2
          empty3
          any1
          any2
          missing
          any3
          category_uniq
          categry_sort
          category_value
        ],
        not_duplicated: %W[],
        not_blank: %W[],
      },
      booktight: {
        valid: %W[
          totalID
          xid
          purchase_date
          bookstore
          title
          asin
          read_status
          shape
          category
        ],
        remove: %W[
          empty1
          empty2
          empty3
          any1
          any2
          missing
          any3
          category_uniq
          categry_sort
          category_value
        ],
        not_duplicated: %W[],
        not_blank: %W[],
      },
    }
  end
=end
end
