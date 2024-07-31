require "pathname"

class DatadirUtils
  attr_reader :output_pn, :export_pn, :input_pn

  def initialize
    @output_pn = ConfigUtils.output_dir_pn
    @export_pn = ConfigUtils.output_export_dir_pn
    @input_pn = ConfigUtils.input_dir_pn
    @output_pn.mkdir() unless @output_pn.exist?
    @export_pn.mkdir() unless @export_pn.exist?
    @input_pn.mkdir() unless @input_pn.exist?
  end
end
