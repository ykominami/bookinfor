require "open-uri"
# require 'nokogiri'
require "json"
require "net/http"
require "nokogiri"
require "pathname"

class DlImporter
  def initialize(cmd:, search_file_pn: nil)
    @logger = LoggerUtils.logger()

    @cmd = cmd
    @search_item = {}
    if search_file_pn
      if search_file_pn.exist?
        @search_item = JsonUtils.parse(search_file_pn)
        @logger.debug "DlImporter#initialize @search_item=#{@search_item}"
      end
    end

    # @src_url = "https://a.northern-cross.net/gas2/a.php"
    @src_url = ConfigUtils.dl_src_url
    # @logger.debug "@src_url=#{@src_url}"
    # ConfigUtilクラスから、output_pnとexport_pnを取得・設定
    @datadir = DatadirUtils.new()
    # @logger.debug "@datadir.output_pn.to_s=#{@datadir.output_pn.to_s}"
    # @logger.debug "@datadir.export_pn.to_s=#{@datadir.export_pn.to_s}"
    @datalist = DatalistUtils.new(dir_pn: @datadir.output_pn)
    # @logger.debug "@datalist=#{@datalist}"
    # @out_json_pn = @datalist.file_pn

    @html_file_path = @datadir.output_pn + ConfigUtils.dl_html_filename
    # @logger.debug "@html_file_path=#{@html_file_path}"
    @out_hash = {}
    @hash_from_html = nil
  end

  def copy_file(src_file, dest_file)
    src_file.each_line { |line| dest_file.puts(line) }
  end

  def do_op(op)
    ret = true
    @logger.debug "do_op op=#{op}"
    case op
    when :CLEAN_ALL_FILES
      clean_all_files()
    when :CLEAN_JSON_FILES
      clean_json_files()
    when :CLEAN_HTML_FILES
      clean_html_files()
    when :GET_HTML
      # 取得内容をHTMLファイルとして保存
      ret = get_and_save_page(@src_url, @html_file_path)
    when :PARSE_HTML
      # HTMLファイルを解析
      @hash_from_html = parse_html_file(@html_file_path)
      ret = false unless @hash_from_html
    when :PARSE_HTML_AND_SHOW
      # HTMLファイルを解析
      @hash_from_html = parse_html_file(@html_file_path)
      @logger.debug @hash_from_html
      ret = false unless @hash_from_html
    when :HASH_TO_JSON_FILE
      # HTMLの解析結果であるハッシュをファイルに保存
      # @logger.debug "@hash_from_html=#{@hash_from_html}"
      # @logger.debug  @hash_from_html
      @out_hash = save_datalist_json_from_html(@hash_from_html)
      # @out_hash = get_data_and_save_from_html(specified_hash)
      if @out_hash
        # @save_hash = @out_hash[:key]
        @save_hash = @out_hash
        ret = false unless @save_hash
      else
        ret = false
      end
      # @logger.debug @out_hash
    when :HASH_TO_JSON_FILE_AND_SHOW
      # HTMLの解析結果であるハッシュをファイルに保存
      @out_hash = save_datalist_json_from_html(@hash_from_html)

      if @out_hash
        @logger.debug @out_hash
        @save_hash = @out_hash
        # @save_hash = @out_hash[:key]
        ret = false unless @save_hash
      else
        ret = false
      end
    when :GET_AND_SAVE
      specified_hash = @datalist.datax(@save_hash, @search_item)
      ret = get_data_and_save_with_hash(specified_hash, @save_hash)
      @logger.debug "ret=#{ret}"
    when :PARSE_JSON_FILE
      @out_hash = @datalist.parse()
      if @out_hash
        # @save_hash = @out_hash[:key]
        @save_hash = @out_hash
      else
        ret = false
      end
    when :SHOW_JSON
      @logger.debug @save_hash
    when :SHOW_JSON_SELECTED
      specified_hash = @datalist.datax(@save_hash, @search_item)
      @logger.debug specified_hash
    when :DATAX
      @save_hash = @datalist.datax(@out_hash, @search_item)
      # @logger.debog ":DATAX @save_hash=#{@save_hash}"
      ret = false unless @save_hash
    else
      @logger.debug "Illeagal op is specified! (#{op})"
      ret = false
    end

    ret
  end

  def data
    # @logger.debug "##########"
    # @logger.debug "DlImporter#get_data @cmd=#{@cmd}"
    op_list = case @cmd
              when :ALL
                %i[CLEAN_ALL_FILES GET_HTML PARSE_HTML HASH_TO_JSON_FILE GET_AND_SAVE]
              when :FROM_HTML
                %i[PARSE_HTML HASH_TO_JSON_FILE GET_AND_SAVE]
              when :FROM_HTML_TO_JSON
                %i[PARSE_HTML HASH_TO_JSON_FILE]
              when :CLEAN_ALL_FILES
                # %i(CLEAN_ALL_FILES)
                %i[CLEAN_JSON_FILES CLEAN_HTML_FILES]
              when :HTML
                %i[GET_HTML PARSE_HTML HASH_TO_JSON_FILE]
              when :HTMLX
                %i[PARSE_HTML HASH_TO_JSON_FILE_AND_SHOW]
              when :DATA_JSON
                # %i(PARSE_JSON GET_AND_SAVE)
                %i[PARSE_JSON_FILE]
              when :DATA_JSON_SHOW
                # %i(PARSE_JSON GET_AND_SAVE)
                %i[PARSE_JSON_FILE SHOW_JSON]
              when :DATA_JSON_SHOW_SELECTED
                # %i(PARSE_JSON GET_AND_SAVE)
                %i[PARSE_JSON_FILE SHOW_JSON_SELECTED]
              when :DATA_JSON_X
                %i[PARSE_JSON_FILE GET_AND_SAVE]
              else
                @logger.debug "iLLEGAL_OP(#{@cmd})"
                %i[ILLGAL_OP]
              end

    # @logger.debug "op_list=#{op_list}"
    op_list.each do |op|
      # @logger.debug "get_data | op=#{op}"
      ret = do_op(op)
      break unless ret
    end
  end

  def clean_all_files
    output_pn = Pathname.new(ConfigUtils.output_dir)
    clean_files_under_dir(output_pn, /\.json/i)
    clean_files_under_dir(output_pn, /\.html/i)
  end

  def clean_json_files
    output_pn = Pathname.new(ConfigUtils.output_dir)
    clean_files_under_dir(output_pn, /\.json/i)
  end

  def clean_html_files
    output_pn = Pathname.new(ConfigUtils.output_dir)
    clean_files_under_dir(output_pn, /\.html/i)
  end

  def clean_files_under_dir(dir_pn, re)
    dir_pn.children.each do |it|
      # @logger.debug it.to_s
      if it.directory?
        clean_files_under_dir(it, re)
      elsif re.match(it.extname)
        # @logger.debug "#{it} unlink"
        FileUtils.rm_f(it)
      end
    end
  end

  def get_and_save_page(src_url, out_fname)
    @logger.debug "DlImporter|get_and_save_page|src_url=#{src_url}"
    ret = true
    begin
      URI.open(src_url) do |f|
        File.open(out_fname, "w") do |out_f|
          copy_file(f, out_f)
        end
      end
    rescue StandardError => exp
      @logger.fatal exp
      @logger.fatal exp.message
      ret = false
    end

    ret
  end

  def parse_html_file(html_fname)
    hash = {}
    html_pn = Pathname.new(html_fname)
    unless html_pn.exist?
      @logger.debug "2 Can't find #{html_pn}"
      return nil
    end
    html = File.read(html_fname)
    page = Nokogiri::HTML(html)
    object = page.css("#itemA")
    # output_link( object )
    get_links(hash, object)

    object = page.css("#itemB")
    get_links(hash, object)

    hash
  end

  def get_links(hash, object)
    object.xpath(".//a").each do |x|
      hash[x.inner_text] = x["href"]
    end
  end

  def add_blank_item(hash)
    new_hash = {}
    if hash
      hash.each do |key, value|
        new_hash[key] = ["", value]
      end
    end
    new_hash
  end

  def save_datalist_json_from_html(hash)
    hash = add_blank_item(hash)
    out_hash = @datalist.parse_datalist_content(hash)
    # @logger.debug "######### DlImporter#save_datalist_json_from_html"
    @datalist.make_output_json(out_hash[:key])
    # @logger.debug "get_data_and_save_from_html"
    # @logger.debug out_hash[:key]
    out_hash
  end

  def get_array(out_hash)
    if out_hash
      out_hash.map do |_key, value|
        if value.instance_of?(Array)
          value
        else
          get_array(value)
        end
      end
    else
      []
    end
  end

  def datax_by_item(hash: hashx, arg1: nil, arg2: nil, arg3: nil)
    num, keyx, value_kind = arg1
    num2, keyx2, value_kind2 = arg2
    num3, keyx3, value_kind3 = arg3

    ret
  end

  def get_data_and_save_with_hash_by_key(out_hash, key)
    # @logger.debug "###==== 0 1 get_data_and_save_with_hash_by_key key=#{key}"
    # puts "###==== 0 1 get_data_and_save_with_hash_by_key key=#{key}"
    ret = true
    if out_hash
      item = out_hash[key]
      if item
        # relative_file = item.relative_file
        src_url = item.src_url
        full_path = item.full_path
        # @logger.debug "###==== 0 2 get_data_and_save_with_hash_by_key key=#{key}"
        # @logger.debug "src_url=#{src_url}"
        # @logger.debug "full_path=#{full_path}"
        ret = get_and_save_page(src_url, full_path)
      else
        ret = false
      end
    }
  end
end
