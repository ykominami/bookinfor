class KindleImporter < BaseImporter
  def initialize(vx, keys, ks, import_date)
    super(vx, keys, ks)
    @name = "kindle"
    @ignore_fields = %w[publisher author publish_date purchase_date read_status category]
    @ar_klass = Kindlelist
    @import_date = import_date
    @ignore_fields = %w[publisher publish_date]
  end

  def xf_supplement(target, x, base_number = nil)
    x["read_status"] = "" unless x["read_status"]
    set_assoc(x, Category, "read_status", "readstatus")
    x.delete("read_status")

    x["shape"] = "Kindle" unless x["shape"]
    set_assoc(x, Shape, "shape", "shape")
    x.delete("shape")
  end

  def select_valid_data_x(x, data_array)
    select_valid_data(x, "purchase_date", "asin", Kindlelist, data_array)
  end
end
