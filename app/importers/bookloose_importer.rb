class BooklooseImporter < BookImporter
  def initialize(vx, keys, ks)
    super(vx, keys, ks)
    @name = "book"
    @ar_klass = Booklistloose
  end
end
