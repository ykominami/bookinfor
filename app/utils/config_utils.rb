class ConfigUtils
  attr_reader :output_pn

  @src_url = "https://a.northern-cross.net/gas2/a.php"
  @html_filename = "b0.html"
  @output_dir = "data"
  @config_dir_pn = Rails.root + "config" + "importers"
  @config_pn = @config_dir_pn + "config.json"
  @datalist_json_filename = "datalist.json"

  def self.dl_src_url
    @src_url
  end

  def self.dl_html_filename
    @html_filename
  end

  def self.output_dir
    @output_dir
  end

  def self.config_dir_pn
    @config_dir_pn
  end

  def self.config_pn
    @config_pn
  end

  def self.datalist_json_filename
    @datalist_json_filename
  end

  def initialize()
  end
end
