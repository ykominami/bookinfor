require "json"

class JsonUtils
  @logger ||= LoggerUtils.logger
  @logger.tagged("#{self.class.name}")

  class << self
    def parse(file)
      @logger.debug "Jsonutil file=#{file}"
      content = File.read(file)
      obj = nil
      return obj if content.nil? || content == ""

      begin
        obj = JSON.parse(content)
      rescue => exc
        LoggerUtils.log_fatel_p exc.class
        LoggerUtils.log_fatel_p "Excception from JSON.parse(content) file=#{file}"
        LoggerUtils.log_fatel_p "Exception in JsonUtils.parse"
      end

      obj
    end

    def output(fio, obj)
      json_str = JSON.pretty_generate(obj)
      pn = Pathname.new(fio)
      @logger.debug "pn.to_s=#{pn}"
      pn.write(json_str)
    end
  end
end
