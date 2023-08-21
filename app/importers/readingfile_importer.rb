class ReadingfileImporter < ReadingImporter
  def initialize(vx, keys, ks, import_date, path_array)
    super(vx, keys, ks, import_date)
    @path_array = path_array
  end

  def load_data
    # p "######### load_data @path=#{@path}"
    # XLSXファイルを開く
    JsonUtils.parse(@path_array.first)
  end
end
