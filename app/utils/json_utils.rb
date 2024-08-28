require "json"

class JsonUtils
  @logger ||= LoggerUtils.logger

  class << self
    def parse(file)
      p "Jsonutil file=#{file}"
      content = File.read(file)
      obj = nil
      begin
        obj = JSON.parse(content)
      rescue => exc
	pp exc.class
	pp exc.message
        pp exc.backtrace
      end

      obj
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
