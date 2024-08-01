class LoggerUtils
  @logger ||= ActiveSupport::TaggedLogging.new(Logger.new($stdout))

  class << self
    def logger
      @logger
    end
  end
end
