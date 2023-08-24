class ReadingImporter < BaseImporter
  def initialize(vx, keys, ks, import_date)
    super(vx, keys, ks)
    @name = "reading"
    @ar_klass = Readinglist
    @import_date = import_date
    @ignore_fields = %w(isbn ISBN)
  end

  def detec_blank(inst, x)
    inst.detect_blank(x, x)
  end

  def select_valid_data_x(x, data_array)
    select_valid_data(x, "register_date", "isbn", Readinglist, data_array)
  end

  def xf_supplement(target, x, base_number = nil)
    # x["shapex"] = x["shape"]
    ret = Shape.find_by(name: x["shape"])
    if ret
      x["shape_id"] = ret.id
    else
      puts "Can't find #{x["shape"]}"
      exit
    end
    x.delete("shape")
  end
end
