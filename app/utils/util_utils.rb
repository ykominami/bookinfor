class UtilUtils
  class << self
    def nil_or_empty?(obj)
      obj.nil? || obj.empty?
    end

    def check_file_exist(fname, dir_pn, exit_code)
      file_pn = nil
      if nil_or_empty?(fname)
        file_pn = dir_pn + fname
        unless file_pn.exist?
          puts "Can't find #{file_pn}"
          exit(exit_code)
        end
      end
      file_pn
    end
  end
end