class LoggerUtils
  f = File.open("log/d.log", File::WRONLY | File::APPEND | File::CREAT)
  @logger ||= ActiveSupport::TaggedLogging.new(Logger.new(f))
  # @logger ||= ActiveSupport::TaggedLogging.new(Logger.new($stdout))

  # @logger.level = Logger::WARN
  @logger.level = Logger::DEBUG

  class << self
    def logger
      @logger
    end
  end
end
