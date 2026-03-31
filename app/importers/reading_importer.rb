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
      select_valid_data(x[k], "register_date", "isbn", Readinglist, data_array) if x[k].instance_of?(Hash)
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
    # shapeは外部キー参照なので、見つからない場合は外部キー違反にならない値にフォールバックする
    ret = Shape.find_by(name: x["shape"])
    if ret
      x["shape_id"] = ret.id
    else
      @logger.debug "1 Can't find #{x["shape"]}"
      blank = Shape.find_by(name: "")
      x["shape_id"] = blank ? blank.id : nil
    end

    # readingstatusは外部キー参照なので、名前→ID解決する
    # 既に外部キーIDが入っている場合は上書きしない
    unless x["readingstatus_id"].is_a?(Integer)
      set_assoc_0(x, Readingstatus, "readingstatus")
    end

    x.delete("shape")
    x.delete("readingstatus")
  end
end
