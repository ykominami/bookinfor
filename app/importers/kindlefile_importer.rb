require "roo"

class KindlefileImporter < KindleImporter
  def initialize(vx, keys, ks, import_date, path_array)
    @logger = LoggerUtils.get_logger()

    super(vx, keys, ks, import_date)
    @path_array = path_array
  end

  def load_data
    # @logger.debug "######### load_data @path=#{@path}"
    # XLSXファイルを開く
    xlsx = Roo::Spreadsheet.open(@path_array.first)

    # シートを選択（デフォルトは最初のシート）
    xlsx.default_sheet = xlsx.sheets.first

    # base_day = Date.new(2023, 7, 17)
    Date.new(2000, 1, 1)
    # シートの内容を読み取る
    row_header = nil
    array = []
    xlsx.each_row_streaming do |row|
      # @logger.debug row
      row_cells = row.map(&:value)
      if row_header.nil?
        row_header = row_cells
        row_cells = nil
      end
      next unless row_cells

      hash = {}
      row_cells.each_with_index do |item, index|
        hash[row_header[index]] = item
      end
      array << hash
    end
    # @logger.debugp array
    array
  end
end
