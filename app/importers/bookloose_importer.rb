class BooklooseImporter < BookImporter
  def initialize(vx, keys, ks, import_date)
    super(vx, keys, ks)
    @name = "book"
    @ar_klass = Booklistloose
    @import_date = import_date
  end
end
