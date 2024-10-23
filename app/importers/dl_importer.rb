require "open-uri"
# require 'nokogiri'
require "json"
require "net/http"
require "nokogiri"
require "pathname"

class DlResultStack
  class DlResult
    attr_accessor :op, :result
    def initialize(op, result)
      @op = op
      @result = result
      @messages = []
    end

    def eql?(other)
      @op == other.op && @result == other.result
    end

    def add_message(msg)
      @messages.push(msg)
    end
  end
  
  def initialize
    @stack = []
  end

  def last
    @stack.last
  end

  def size
    @stack.size
  end

  def empty?
    @stack.empty?
  end

  def peek_at(index)
    @stack[index]
  end

  def add(result)
    @stack.push(result)
  end

  def dump
    @stack.each do |it|
      p it
    end
  end
end

class DlImporter
  class << self
    def fix_cmd(cmd)
      cmd_downcase = cmd.downcase
      case cmd_downcase
      when "all"
        cmd = :ALL
      when "data_json"
        cmd = :DATA_JSON
      when "data_json_show"
        cmd = :DATA_JSON_SHOW
      when "data_json_show_selected"
        cmd = :DATA_JSON_SHOW_SELECTED
      when "data_json_x"
        cmd = :DATA_JSON_X
      when "html"
        cmd = :HTML
      when "fromhtml"
        cmd = :FROM_HTML
      when "fromhtmltojson"
        cmd = :FROM_HTML_TO_JSON
      when "htmlx"
        cmd = :HTMLX
      when "clean_all_files"
        cmd = :CLEAN_ALL_FILES
      else
        cmd = :NOTHING
      end

      if cmd == :NOTHING
        LoggerUtils.log_fatal_p "Invalid command(#{cmd_downcase}) is specified!"
        exit(10)
      end

      cmd
    end
  end

  def initialize(cmd:, search_file_pn: nil)
    @logger = LoggerUtils.logger()
    @logger.tagged("#{self.class.name}")


    @cmd = cmd
    @search_item = {}
    if search_file_pn
      if search_file_pn.exist?
        @search_item = JsonUtils.parse(search_file_pn)
        @logger.debug "DlImporter#initialize @search_item=#{@search_item}"
      end
    end

    @src_url = ConfigUtils.dl_src_url
    # ConfigUtilクラスから、output_pnとexport_pnを取得・設定
    @datadir = DatadirUtils.new()
    @datalist = DatalistUtils.new(dir_pn: @datadir.output_pn)

    @html_file_path = @datadir.output_pn + ConfigUtils.dl_html_filename
    @out_hash = {}
    @hash_from_html = nil
  end

  def copy_file(src_file, dest_file)
    src_file.each_line { |line| dest_file.puts(line) }
  end

  def do_op(op)
    dlresult = DlResultStack::DlResult.new(op, false)

    @logger.debug "do_op op=#{op}"
    case op
    when :CLEAN_ALL_FILES
      clean_all_files(dlresult)
      dlresult.result = true
    when :CLEAN_JSON_FILES
      clean_json_files(dlresult)
      dlresult.result = true
    when :CLEAN_HTML_FILES
      clean_html_files(dlresult)
    when :GET_HTML
      # 取得内容をHTMLファイルとして保存
      get_and_save_page(@src_url, @html_file_path, dlresult)
    when :PARSE_HTML
      # HTMLファイルを解析
      @hash_from_html = parse_html_file(@html_file_path, dlresult)
    when :PARSE_HTML_AND_SHOW
      # HTMLファイルを解析
      @hash_from_html = parse_html_file(@html_file_path, dlresult)
      @logger.debug @hash_from_html
    when :HASH_TO_JSON_FILE
      # HTMLの解析結果であるハッシュをファイルに保存
      @out_hash = save_datalist_json_from_html(@hash_from_html, dlresult)
      if @out_hash
        @save_hash = @out_hash
      end
      # @logger.debug @out_hash
    when :HASH_TO_JSON_FILE_AND_SHOW
      # HTMLの解析結果であるハッシュをファイルに保存
      @out_hash = save_datalist_json_from_html(@hash_from_html, dlresult)

      if @out_hash
        @logger.debug @out_hash
        @save_hash = @out_hash
        # @save_hash = @out_hash[:key]
      end
    when :GET_AND_SAVE
      specified_hash = @datalist.datax(@save_hash, @search_item)
      get_data_and_save_with_hash(specified_hash, @save_hash, dlresult)
      @logger.debug "dlresult.result=#{dlresult.result}"
    when :PARSE_JSON_FILE
      dlresult.result = true
      @out_hash = @datalist.parse()
      if @out_hash
        # @save_hash = @out_hash[:key]
        @save_hash = @out_hash
      else
        dlresult.result = false
      end
    when :SHOW_JSON
      @logger.debug @save_hash
      dlresult.result = true
    when :SHOW_JSON_SELECTED
      specified_hash = @datalist.datax(@save_hash, @search_item)
      @logger.debug specified_hash
      dlresult.result = true
    when :DATAX
      dlresult.result = true
      @save_hash = @datalist.datax(@out_hash, @search_item)
      # @logger.debog ":DATAX @save_hash=#{@save_hash}"
      dlresult.result = false unless @save_hash
    else
      message = "Illeagal op is specified! (#{op})"
      @logger.debug message
      dlresult.result = false
    end

    dlresult
  end

  def execute_data_op
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
    result_stack = DlResultStack.new
    op_list.each do |op|
      result_item = do_op(op)
      result_stack.add(result_item)
      break unless result_item.result
    end
    result_stack
  end

  def clean_all_files(dlresult)
    output_pn = Pathname.new(ConfigUtils.output_dir)
    clean_files_under_dir(output_pn, /\.json/i, dlresult)
    if dlresult
      clean_files_under_dir(output_pn, /\.html/i, dlresult)
    end
  end

  def clean_json_files(dlresult)
    output_pn = Pathname.new(ConfigUtils.output_dir)
    clean_files_under_dir(output_pn, /\.json/i, dlresult)
  end

  def clean_html_files(dlresult)
    output_pn = Pathname.new(ConfigUtils.output_dir)
    clean_files_under_dir(output_pn, /\.html/i, dlresult)
  end

  def clean_files_under_dir(dir_pn, re, dlresult)
    dir_pn.children.each do |it|
      if it.directory?
        clean_files_under_dir(it, re, dlresult)
      elsif re.match(it.extname)
        FileUtils.rm_f(it)
      end
      break unless dlresult.result
    end
  end

  def get_and_save_page(src_url, out_fname, dlresult)
    @logger.debug "DlImporter|get_and_save_page|src_url=#{src_url}"
    dlresult.result = true
    begin
      URI.open(src_url) do |f|
        File.open(out_fname, "w") do |out_f|
          copy_file(f, out_f)
        end
      end
    rescue StandardError => exp
      @logger.fatal exp
      @logger.fatal exp.message
      dlresult.result = false
    end

    dlresult.result
  end

  def parse_html_file(html_fname, dlresult)
    dlresult.result = true
    hash = {}
    html_pn = Pathname.new(html_fname)
    unless html_pn.exist?
      message = "2 Can't find #{html_pn}"
      @logger.debug(message)
      dlresult.add_message(message)
      dlresult.result = false
      return nil
    end
    html = File.read(html_fname)
    page = Nokogiri::HTML(html)
    object = page.css("#itemA")
    get_links(hash, object)

    object2 = page.css("#itemB")
    get_links(hash, object2)
    dlresult.result = false unless hash

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

  def save_datalist_json_from_html(hash, dlresult)
    dlresult.result = true
    hash = add_blank_item(hash)
    out_hash = @datalist.parse_datalist_content(hash)
    if out_hash
      @datalist.make_output_json(out_hash[:key])
    else
      dlresult.result = false
    end 
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

  def get_data_and_save_with_hash(selected_hash, out_hash, dlresult)
    dlresult.result = true
    if selected_hash
      get_array(selected_hash).flatten.each do |key|
        dlresult.result = get_data_and_save_with_hash_by_key(out_hash[:key], key, dlresult)
        break unless dlresult.result
      end
    end

    dlresult.result
  end

  def get_data_and_save_with_hash_by_key(out_hash, key, dlresult)
    dlresult.result = false
    if out_hash
      item = out_hash[key]
      if item
        src_url = item.src_url
        full_path = item.full_path
        get_and_save_page(src_url, full_path, dlresult)
      end
    end
  end
end
