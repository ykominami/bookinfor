class ReadingImporter < BaseImporter
  def initialize(vx, keys, ks, import_date)
    @logger = LoggerUtils.logger
    @logger.tagged("#{self.class.name}")


    super(vx, keys, ks)
    @name = "reading"
    @ar_klass = Readinglist
    @import_date = import_date
    @ignore_fields = %w[isbn ISBN]
  end

  def detec_blank(inst, x)
    inst.detect_blank(x, x)
  end

  def select_valid_data_y(x, data_array)
    select_valid_data(x, "register_date", "isbn", Readinglist, data_array)
  end

  def select_valid_data_x(x, data_array)
    keys = x.keys
    keys.each do |k|
      if x[k].instance_of?(Hash)
        select_valid_data(x[k], "register_date", "isbn", Readinglist, data_array)
      else
        # p "#### reading_importer#select_valid_data_x x[#{k}].class=#{x[k].class}"
      end
    end
  end

  def xf_supplement_x(x, base_number = nil)
    keys = x.keys
    keys.each do |k|
      xf_supplement(x[k], base_number)
    end
  end

  private

  def xf_supplement(x)
    ret = Shape.find_by(name: x["shape"])
    if ret
      x["shape_id"] = ret.id
    else
      @logger.debug "1 Can't find #{x["shape"]}"
      x["shape_id"] = -1

    end

    # set_assoc(x, Category, "read_status", "readstatus")
    set_assoc(x, Readingstatus, "readingstatus")

    x.delete("shape")

    x.delete("readingstatus")
  end
end
