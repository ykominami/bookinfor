class BooktightImporter < BookImporter
  def initialize(vx, keys, ks)
    super(vx, keys, ks)
    @name = "book"
    @ar_klass = Booklisttight
  end
end
