class BookfileImporter < BookImporter
  def initialize(vx, keys, ks, import_date, path_hash)
    super(vx, keys, ks, import_date)
    @path_hash = path_hash
  end

  def load_data(item:, year: nil)
    year_str = %(#{year})
    # p year_str
    # p @path_hash
    JsonUtils.parse(@path_hash[year_str])
  end
end
