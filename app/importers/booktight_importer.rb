class BooktightImporter < BookImporter
  def initialize(vx, keys, ks, import_date)
    super(vx, keys, ks)
    @name = "book"
    @ar_klass = Booklisttight
    @import_date = import_date
  end
end
