module ReadinglistsHelper
  class Reainglistx
    attr_reader :header, :body, :name

    def initialize(name, readinglists)
      @logger = LoggerUtils.logger

      @name = name
      @readinglists = readinglists
      # @keys = %i(register_date date title status shape isbn)
      # @keys = %i(shape category date title status read_status isbn)
      @keys = %i(shape category date title read_status isbn)
      key_header = { read_status: "re" }
      @header = @keys.map { |key| key_header[key].nil? ? key.to_s : key_header[key] }

      @header = @keys.map { |key| key.to_s }
      @body = @readinglists.map do |item|
        @logger.debug @readinglists
        array = []
        @keys.each_with_index do |key, index|
          case index
          when 0 | 3 | 4
            array << { str: item[key], attr: 50 }
          when 1
            array << { str: item.category.name, attr: 100 }
          when 2
            array << { str: item[key], attr: 100 }
          when 3
<<<<<<< HEAD
            array << { str: item[key], attr: 400 }
            # array << { str: item[key], attr: 50 }
||||||| parent of 6302700 (use kaminari and tbl component)
            array << { str: item[key], attr: 50 }
=======
            array << { str: item[key], attr: 400 }
>>>>>>> 6302700 (use kaminari and tbl component)
          when 4
<<<<<<< HEAD
            # array << { str: item.readstatus.name, attr: 100 }
            array << { str: item[key], attr: 50 }
            # array << { str: item.readstatus.name, attr: 50 }
          when 5
            # array << { str: item.readstatus.name, attr: 100 }
            # array << { str: item.readstatus.name, attr: 50 }
            array << { str: item[key], attr: 50 }
            # array << { str: item.readstatus.name, attr: 50 }
||||||| parent of 6302700 (use kaminari and tbl component)
            array << { str: item.readstatus.name, attr: 50 }
=======
            array << { str: item.readstatus.name, attr: 100 }
>>>>>>> 6302700 (use kaminari and tbl component)
          else
            array << { str: item[key], attr: "" }
          end
        end
        array
      end
    end
  end
end
