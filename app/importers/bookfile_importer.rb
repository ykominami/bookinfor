class BookfileImporter < BookImporter
  def initialize(vx, keys, ks, import_date, path_hash)
    @logger = LoggerUtils.logger()
    @logger.tagged("#{self.class.name}")

    super(vx, keys, ks, import_date)
    @path_hash = path_hash
  end

  def load_data(item:, year: nil)
    year_str = %(#{year})
    content = @path_hash[year_str]
    if content && content.strip.size.positive?
      JsonUtils.parse(content)
    else
      {}
    end
  end
end
