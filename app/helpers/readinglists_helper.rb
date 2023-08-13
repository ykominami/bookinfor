module ReadinglistsHelper
  class Reainglistx
    attr_reader :header, :body, :name

    def initialize(name, readinglists)
      @name = name
      @readinglists = readinglists
      # @keys = %i(register_date date title status shape isbn)
      @keys = %i(shape category date title status read_status isbn)
      key_header = { read_status: "re" }
      @header = @keys.map { |key| key_header[key] != nil ? key_header[key] : key.to_s }

      @header = @keys.map { |key| key.to_s }
      @body = @readinglists.map { |item|
        p @readinglists
        array = []
        @keys.each_with_index { |key, index|
          case index
          when 0
            array << { str: item[key], attr: 50 }
          when 1
            array << { str: item.category.name, attr: 100 }
          when 2
            array << { str: item[key], attr: 100 }
          when 3
            array << { str: item[key], attr: 50 }
          when 4
            array << { str: item[key], attr: 50 }
          when 5
            array << { str: item.readstatus.name, attr: 50 }
          else
            array << { str: item[key], attr: "" }
          end
        }
        array
      }
    end
  end
end
