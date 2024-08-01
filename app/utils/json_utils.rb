require "json"

class JsonUtils
  @logger ||= LoggerUtils.get_logger()

  class << self
    def parse(file)
      content = File.read(file)
      JSON.parse(content)
    end

    def output(fio, obj)
      @logger.debug "============================ JsonUtils.output"
      json_str = JSON.pretty_generate(obj)
      pn = Pathname.new(fio)
      # @logger.debug "json_str=#{json_str}"
      @logger.debug "pn.to_s=#{pn}"
      pn.write(json_str)
    end
  end
end
