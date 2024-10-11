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

      pp ""
      pp ""
      pp ""
      pp ""
      pp "======= S"
      pp "JsonUtils.parse file=#{file}"
      # puts "content=#{content}"
      pp "======= E"
      pp ""
      begin
        obj = JSON.parse(content)
      rescue => exc
        pp exc.class
        pp "Excception from JSON.parse(content) file=#{file}"
        # pp exc.message
        # pp exc.backtrace
        pp "Exception in JsonUtils.parse"
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
