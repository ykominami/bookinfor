class ConfigUtils
  class Configx
    def initialize(path_pn)
      @path_pn = path_pn
      @json = JsonUtils.parse(@path_pn)
      @obj = @json["xkeys"]
    end

    def get_keys
      @json["keys"]
    end

    def get_class(key)
      @obj[key]["ac_klass"].constantize
    end
  end

  attr_reader :output_pn

  @html_filename = "b0.html"
  @data_dir = "data"
  @output_dir = @data_dir
  @input_dir = @data_dir

  # @config_dir_pn = Rails.root + "config" + "importers"

  @config_dir_pn = Rails.root + "config"
  @importer_config_dir_pn = @config_dir_pn + "importers"
  @exporter_config_dir_pn = @config_dir_pn + "exporters"

  # @src_url = "https://a.northern-cross.net/gas2/a.php"
  @setting_pn = @importer_config_dir_pn + "setting.json"
  setting_json = JsonUtils.parse(@setting_pn)
  @src_url = setting_json["src_url"]
  # puts "@src_url=#{@src_url}"

  @output_dir_pn = Rails.root + @output_dir
  @export_output_dir_pn = @output_dir_pn + "export"

  @input_dir_pn = Rails.root + @input_dir

  @config_pn = @importer_config_dir_pn + "config.json"

  @aux_dbtbl_pn = @importer_config_dir_pn + "aux_dbtbl.json"

  @datalist_json_filename = "datalist.json"
  
  @search_json_filename = "search.json"
  @search_json_pn = @importer_config_dir_pn + @search_json_filename
  # puts "Configutils @search_json_pn=#{@search_json_pn}"
  @state_pn = @importer_config_dir_pn + "state.json"
  @use_import_date = false

  @export_from_db_dir = "export"
  @output_export_dir_pn = @output_dir_pn + @export_from_db_dir
  @import_from_exported_data = ""

  @default_import_date = Date.new(2000, 1, 1)

  class << self
    def default_import_date
      @default_import_date
    end

    def output_export_dir_pn
      @output_export_dir_pn
    end

    def get_configx(path)
      Configx.new(path)
    end

    def output_dir_pn
      @output_dir_pn
    end

    def input_dir_pn
      @input_dir_pn
    end

    def export_output_dir_pn
      @export_output_dir_pn
    end

    def config_dir_pn
      @config_dir_pn
    end

    def aux_dbtbl_pn
      @aux_dbtbl_pn
    end

    def importer_config_dir_pn
      @importer_config_dir_pn
    end

    def exporter_config_dir_pn
      @exporter_config_dir_pn
    end

    def dl_src_url
      @src_url
    end

    def dl_html_filename
      @html_filename
    end

    def output_dir
      @output_dir
    end

    def input_dir
      @input_dir
    end

    def config_pn
      @config_pn
    end

    def state_pn
      @state_pn
    end

    def datalist_json_filename
      @datalist_json_filename
    end

    def use_import_date?
      @use_import_date
    end

    def use_import_date=(value)
      @use_import_date = value
    end

    def search_json_filename
      @search_json_filename
    end

    def search_json_pn
      @search_json_pn
    end
  end

  def initialize()
  end
end
