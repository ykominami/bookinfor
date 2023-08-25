class BookfileImporter < BookImporter
  def initialize(vx, keys, ks, import_date, path_hash)
    super(vx, keys, ks, import_date)
    @path_hash = path_hash
  end

  def load_data(item:, year: nil)
    year_str = %(#{year})
    #p year_str
    #p @path_hash
    # raise
    content = @path_hash[year_str]
    if content && content.strip.size > 0
      JsonUtils.parse(content)
    else
      # puts "year_str=#{year_str}"
      # puts "content=#{content}"
      raise
      ""
    end
  end
end
