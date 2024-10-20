require "yaml"

class YamlUtils
  @logger ||= LoggerUtils.logger
  @logger.tagged("#{self.class.name}")

  class << self
    def parse(file)
      @logger.debug "Yamlutil file=#{file}"
      content = File.read(file)
      obj = nil
      return obj if content.nil? || content == ""

      begin
        obj = YAML.safe_load(content)
      rescue => exc
        LoggerUtils.log_fatel_p exc.class
        LoggerUtils.log_fatel_p "Excception from YAML.safe_load(content) file=#{file}"
        LoggerUtils.log_fatel_p "Exception in YamlUtils.parse"
      end

      obj
    end

    def output(fio, obj)
      @logger.debug "============================ YamlUtils.output"
      json_str = YAML.dump(obj)
      pn = Pathname.new(fio)
      @logger.debug "pn.to_s=#{pn}"
      pn.write(json_str)
    end
  end
end
