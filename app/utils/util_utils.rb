class UtilUtils
  @logger = LoggerUtils.logger()

  class << self
    def nil_or_empty?(obj)
      obj.nil? || obj.empty?
    end

    def nil_or_empty_string?(obj)
      obj.nil? || obj.strip.size.zero?
    end

    def check_file_exist(fname, dir_pn, exit_code)
      @logger.debug "check_file_exist fname=#{fname} dir_pn=#{dir_pn}"
      if nil_or_empty?(fname)
        file_pn = nil
      else
        file_pn = dir_pn.join(fname)
        @logger.debug "check_file_exist fname=#{fname} file_pn=#{file_pn}"
        unless file_pn.exist?
          msg = "Can't find #{file_pn}"
          LoggerUtils.log_debug_p(msg, @logger)
          msg = "UtilUtils.check_file_exit fname=#{fname} dir_pn=#{dir_pn} exit_code=#{exit_code}"
          LoggerUtils.log_debug_p(msg, @logger)
          exit(exit_code)
        end
      end
      file_pn
    end

    def dump_hash(new_hash, var_name = "")
      new_hash.each_key do |kind|
        new_hash[kind].each_key do |kindx|
          msg = "#{var_name}[#{kind}][#{kindx}]=#{new_hash[kind][kindx]}"
          LoggerUtils.log_debug_p(msg, @logger)
        end
      end
    end  
  end
end
