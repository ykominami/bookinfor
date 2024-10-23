class KindleImporter < BaseImporter
  def initialize(vx, keys, ks, import_date)
    @logger = LoggerUtils.logger()
    @logger.tagged("#{self.class.name}")

    super(vx, keys, ks)
    @name = "kindle"
    @ignore_fields = %w[publisher author publish_date purchase_date read_status category]
    @ar_klass = Kindlelist
    @import_date = import_date
    @ignore_fields = %w[publisher publish_date]
  end

  def xf_supplement_x(x, base_number = nil)
    keys = x.keys
    keys.each do |k|
      xf_supplement(x[k], base_number = nil)
    end
  end

  def select_valid_data_y(x, data_array)
    select_valid_data(x, "purchase_date", "asin", Kindlelist, data_array)
  end
  
  def select_valid_data_x(x, data_array)
    keys = x.keys
    keys.each do |k|
      if x[k].instance_of?(Hash)
        select_valid_data(x[k], "purchase_date", "asin", Kindlelist, data_array)
      end
    end
  end
end

private

def xf_supplement(x, base_number = nil)
  x["read_status"] = "" unless x["read_status"]
  set_assoc(x, Readstatus, "read_status", "readstatus")
  x.delete("read_status")

  x.delete("readstatus")

  x["shape"] = "Kindle" unless x["shape"]
  set_assoc(x, Shape, "shape")
  x.delete("shape")
end
