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

  @src_url = "https://a.northern-cross.net/gas2/a.php"
  @html_filename = "b0.html"
  @output_dir = "data"
  # @config_dir_pn = Rails.root + "config" + "importers"

  @config_dir_pn = Rails.root + "config"
  @importer_config_dir_pn = @config_dir_pn + "importers"
  @exporter_config_dir_pn = @config_dir_pn + "exporters"

  @output_dir_pn = Rails.root + @output_dir
  @export_output_dir_pn = @output_dir_pn + "export"

  @config_pn = @importer_config_dir_pn + "config.json"

  @aux_dbtbl_pn = @importer_config_dir_pn + "aux_dbtbl.json"

  @datalist_json_filename = "datalist.json"
  @state_pn = @importer_config_dir_pn + "state.json"
  @use_import_date = false

  @export_from_db_dir = "export"
  @output_export_dir_pn = @output_dir_pn + @export_from_db_dir
  @import_from_exported_data = ""

  def self.output_export_dir_pn
    @output_export_dir_pn
  end

  def self.get_configx(path)
    Configx.new(path)
  end

  def self.output_dir_pn
    @output_dir_pn
  end

  def self.export_output_dir_pn
    @export_output_dir_pn
  end

  def self.config_dir_pn
    @config_dir_pn
  end

  def self.aux_dbtbl_pn
    @aux_dbtbl_pn
  end

  def self.importer_config_dir_pn
    @importer_config_dir_pn
  end

  def self.exporter_config_dir_pn
    @exporter_config_dir_pn
  end

  def self.dl_src_url
    @src_url
  end

  def self.dl_html_filename
    @html_filename
  end

  def self.output_dir
    @output_dir
  end

  def self.config_pn
    @config_pn
  end

  def self.state_pn
    @state_pn
  end

  def self.datalist_json_filename
    @datalist_json_filename
  end

  def self.use_import_date
    @use_import_date
  end

  def self.use_import_date=(value)
    @use_import_date = value
  end

  def initialize()
  end
end
