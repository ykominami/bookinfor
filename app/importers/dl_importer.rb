require "open-uri"
# require 'nokogiri'
require "json"
require "pp"
require "open-uri"
require "net/http"
require "nokogiri"
require "pathname"

class DlImporter
  def initialize(cmd:, search_file_pn: nil)
    p "search_file_pn=#{search_file_pn}"
    @cmd = cmd
    @search_item = {}
    if search_file_pn
      if search_file_pn.exist?
        @search_item = JsonUtils.parse(search_file_pn)
      end
    end

    @src_url = "https://a.northern-cross.net/gas2/a.php"
    @datadir = DatadirUtils.new()
    @datalist = DatalistUtils.new(dir_pn: @datadir.output_pn)
    # @out_json_pn = @datalist.file_pn

    @html_file_path = @datadir.output_pn + "b0.html"
    @out_hash = {}
    @hash_from_html = nil
  end

=begin
  def fetch(uri_str, limit = 10)
    # You should choose better exception.
    raise ArgumentError, "HTTP redirect too deep" if limit == 0

    url = URI.parse(uri_str)
    req = Net::HTTP::Get.new(url.path, { "User-Agent" => "Mozilla/5.0 (etc...)" })
    response = Net::HTTP.start(url.host, url.port, use_ssl: true) { |http| http.request(req) }
    case response
    when Net::HTTPSuccess then response
    when Net::HTTPRedirection then fetch(response["location"], limit - 1)
    else
      response.error!
    end
  end
=end
  def copy_file(src_file, dest_file)
    src_file.each_line { |line| dest_file.puts(line) }
  end

  def do_op(op)
    p "do_op op=#{op}"
    case op
    when :GET_HTML
      # 取得内容をHTMLファイルとして保存
      get_and_save_page(@src_url, @html_file_path)
    when :PARSE_HTML
      # HTMLファイルを解析
      @hash_from_html = parase_html_file(@html_file_path)
    when :PARSE_HTML_AND_SHOW
      # HTMLファイルを解析
      @hash_from_html = parase_html_file(@html_file_path)
      # pp @hash_from_html
    when :HASH_TO_JSON_FILE
      # HTMLの解析結果であるハッシュをファイルに保存
      # p "@hash_from_html=#{@hash_from_html}"
      @out_hash = get_data_and_save_from_html(@hash_from_html)
    when :HASH_TO_JSON_FILE_AND_SHOW
      # HTMLの解析結果であるハッシュをファイルに保存
      # p "@hash_from_html=#{@hash_from_html}"
      @out_hash = get_data_and_save_from_html(@hash_from_html)
      #pp @out_hash
    when :GET_AND_SAVE
      get_data_and_save_with_hash(@out_hash)
    when :PARSE_JSON
      @out_hash = datalist.parse()
    when :DATAX
      datax(@out_hash, @search_item)
    else
      puts "Illeagl op is specified! (#{op})"
      #
    end
  end

  def get_data
    op_list = case @cmd
      when :ALL
        %i(GET_HTML PARSE_HTML HASH_TO_JSON_FILE GET_AND_SAVE)
        #
      when :HTML
        %i(GET_HTML PARSE_HTML HASH_TO_JSON_FILE)
        #
      when :HTMLX
        %i(PARSE_HTML PARSE_HTM HASH_TO_JSON_FILE_AND_SHOW)
        #
      when :DATA
        %i(PARSE_JSON GET_AND_SAVE)
      when :DATAX
        %i(PARSE_JSON DATAX)
        #
      else
        %i()
        #
      end

    p "op_list=#{op_list}"
    op_list.each do |op|
      p "get_data | op=#{op}"
      do_op(op)
    end
  end

  def get_and_save_page(src_url, out_fname)
    # p "src_url=#{src_url}"
    URI.open(src_url) { |f|
      #  f.each_line{ |line| p line }
      File.open(out_fname, "w") { |out_f|
        copy_file(f, out_f)
      }
    }
  end

  def parase_html_file(html_fname)
    hash = {}
    html = File.read(html_fname)
    po = nil
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

  def get_data_and_save_from_html(hash)
    # pp hash
    # pp "===="
    out_hash = @datalist.make_content_of_out_json(hash)
    # pp out_hash
    # pp "==== 1"
    @datalist.make_output_json(out_hash)
    out_hash
  end

  def get_data_and_save_with_hash(out_hash)
    out_hash.keys.map { |key|
      get_data_and_save_with_hash_by_key(out_hash, key)
    }
  end

  def get_data_and_save_with_hash_by_key(out_hash, key)
    # p "out_hash=#{out_hash}"
    # p "key=#{key}"
    # p "out_hash[key]=#{ out_hash[key] }"
    # output_file, src_url = out_hash[key]
    item = out_hash[key]
    relative_file = item.relative_file
    full_path = item.full_path
    src_url = item.src_url
    # p "relative_file=#{relative_file}"
    # p "full_path=#{full_path}"
    # p "@datadir.output_pn=#{@datadir.output_pn}"
    get_and_save_page(src_url, full_path)
  end

  #=========================(fro datax)

  def datax(hash, search_item)
    p "datax"
    # p search_item
    search_item.keys.map { |kind|
      p "kind=#{kind}"
      search_item[kind].map { |kindx|
        p "kindx=#{kindx}"
        p kind
        p kindx
        case kind
        when "api"
          kind_index = 1
          kindx_index = 4
        else
          kind_index = 1
          kindx_index = 5
        end
        datax_by_item(hash: hash, arg1: [kind_index, kind, :string], arg2: [kindx_index, kindx, :string])
        # pp datax_by_item(hash: hash, arg1: [1, kind, :string])
      }
    }
  end

  def datax_by_item(hash: hashx, arg1: nil, arg2: nil, arg3: nil)
    num, keyx, value_kind = arg1
    num2, keyx2, value_kind2 = arg2
    num3, keyx3, value_kind3 = arg3

    hash.keys.select { |key|
      item = hash[key]
      var1 = item.array[num]
      var2 = item.array[num2]
      var3 = item.array[num3]
      if keyx2 == ":all"
        if keyx3 == ":all"
          var1 == keyx
        else
          var1 == keyx && var3 == keyx3
        end
      else
        if keyx3 == ":all"
          var1 == keyx && var2 == keyx2
        else
          var1 == keyx && var2 == keyx2 && var3 == keyx3
        end
      end
    }
  end
end
