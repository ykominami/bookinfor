class LoggerUtils
  f = File.open("log/d.log", File::WRONLY | File::APPEND | File::CREAT)
  @logger ||= ActiveSupport::TaggedLogging.new(Logger.new(f))
  # @logger ||= ActiveSupport::TaggedLogging.new(Logger.new($stdout))

  @logger.level = Logger::WARN
  # @logger.level = Logger::DEBUG

  class << self
    def level=(level)
      @logger.level = level
    end

    def level
      @logger.level
    end

    def logger
      @logger
    end

    def log_fatal_p(msg, logger = nil)
      logger ||= @logger
      logger.fatal msg
      p msg if logger.level == Logger::FATAL
    end

    def log_debug_p(msg, logger = nil)
      logger ||= @logger
      logger.debug msg
      p msg if logger.level == Logger::DEBUG
    end

    def log_warn_p(msg, logger = nil)
      logger ||= @logger
      logger.warn msg
      p msg if logger.level == Logger::WARN
    end

    def log_info_p(msg, logger = nil)
      logger ||= @logger
      logger.info msg
      p msg if logger.level == Logger::INFO
    end
  end
end
