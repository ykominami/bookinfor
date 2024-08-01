class BookfileImporter < BookImporter
  def initialize(vx, keys, ks, import_date, path_hash)
    @logger = LoggerUtils.logger()

    super(vx, keys, ks, import_date)
    @path_hash = path_hash
  end

  def load_data(item:, year: nil)
    year_str = %(#{year})
    # @logger.debug  year_str
    # @logger.debug  @path_hash
    # raise
    content = @path_hash[year_str]
    if content && content.strip.size.positive?
      JsonUtils.parse(content)
    else
      # @logger.debug "year_str=#{year_str}"
      # @logger.debug "content=#{content}"
      # raise
      ""
    end
  end
end
