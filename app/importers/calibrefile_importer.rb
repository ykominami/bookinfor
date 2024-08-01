class CalibrefileImporter < CalibreImporter
  def initialize(vx, keys, ks, import_date, path_array)
    @logger = LoggerUtils.logger()

    super(vx, keys, ks, import_date)
    @path_array = path_array
  end

  def load_data
    # @logger.debug "######### load_data @path=#{@path}"
    # XLSXファイルを開く
    JsonUtils.parse(@path_array.first)
  end
end
