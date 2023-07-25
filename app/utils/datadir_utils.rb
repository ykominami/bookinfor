require 'pathname'

class DatadirUtils
  attr_reader :output_pn

  def initialize()
    @output_dir = "data"
    @output_pn = Pathname.new(@output_dir)
    @output_pn.mkdir() unless @output_pn.exist?
  end

end
