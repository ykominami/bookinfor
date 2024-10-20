class BookDetectorImporter < DetectorImporter
  def initialize
    @logger = LoggerUtils.logger()
    @logger.tagged("#{self.class.name}")
  end

  def show_detected
    # show_blank_fields
    # show_duplicated_fields
    # @logger.debug "# show_detected (ImporterBook) S"

    count = super()
    count += show_duplicated_field("title")
    # @logger.debug "# show_detected (ImporterBook) E"
    count
  end

  def detect(target, reg_hash)
    reg_hash.find do |key, reg_array|
      retb = reg_array.find do |reg|
        word = target[key]
        reta = reg.match(word)
        !reta.nil?
      end
      !retb.nil?
    end
  end

  def detect_ignore_items(target, reg_hash)
    !detect(target, reg_hash).nil?
  end
end

