class KindleImporter < BaseImporter
  def initialize(vx, keys, ks, import_date)
    super(vx, keys, ks)
    @name = "kindle"
    @ignore_fields = %W(publisher author publish_date purchase_date read_status category)
    @ar_klass = Kindlelist
    @import_date = import_date
    @ignore_fields = %w(publisher publish_date)
  end

  def select_valid_data_x(x, data_array)
    select_valid_data(x, "purchase_date", "asin", Kindlelist, data_array)
  end
end
