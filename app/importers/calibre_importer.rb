class CalibreImporter < BaseImporter
  class CalibreDetectorImporter < DetectorImporter
    def show_detected
      count = super()
      count += show_duplicated_field("title")
      count
    end

    def blank_field_init
      super()
      @blank_keys["cover"] = 0
    end
  end

  def initialize(vx, keys, ks, import_date)
    @logger = LoggerUtils.logger()
    @logger.tagged("#{self.class.name}")


    super(vx, keys, ks)
    @name = "calibre"
    @ar_klass = Calibrelist
    @import_date = import_date

    @field_list = %w[isbn series comments publisher size tags identifiers rating formats]

    # @ignore_fields = @field_list + %W(series_index library_name languages zid authors author_sort pubdate)
    @ignore_fields = @field_list + %w[series_index library_name languages authors author_sort pubdate]
  end

  def select_valid_data_x(x, data_array)
    keys = x.keys
    keys.each do |k|
      if x[k].instance_of?(Hash)
        select_valid_data(x[k], "timestamp", "zid", Calibrelist, data_array)        
      else
        p "#### calibre_importer#select_valid_data_x x[#{k}].class=#{x[k].class}"        
        raise    
      end
    end
  end

  def select_valid_data_y(x, data_array)
    select_valid_data(x, "timestamp", "zid", Calibrelist, data_array)        
  end

  def xf_supplement(x, base_number = nil)
    x["zid"] = x["xid"].nil? ? x["zid"] : x["xid"]
  end
end
