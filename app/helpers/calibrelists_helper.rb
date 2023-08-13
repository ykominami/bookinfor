module CalibrelistsHelper
  class Calibrelistx
    attr_reader :header, :body, :name

    def initialize(name, calibrelists)
      @name = name
      @calibrelists = calibrelists
      # @keys = %i(title authors timestamp tags publisher languages)
      @keys = %i(read_status category title authors tags publisher)
      key_header = { :read_status => "re" }
      @header = @keys.map { |key| key_header[key] ? key_header[key] : key.to_s }
      # @header = %W(read category title authors tags publisher)

=begin
      @keys = %i(xid read_status category title title_sort tags xxid uuid isbn zid comments size series series_index
                       library_name formats timestamp pubdate publisher authors author_sort languages 
                       rating identifiers)
=end
      @body = @calibrelists.map { |item|
        array = []
        @keys.each_with_index { |key, index|
          case index
          when 0
            array << { str: item[key], attr: 50 }
          when 1
            array << { str: item[key], attr: 50 }
          when 2
            array << { str: item[key], attr: 100 }
          when 3
            array << { str: item[key], attr: 50 }
          when 4
            array << { str: item[key], attr: 50 }
          when 5
            array << { str: item[key], attr: 50 }
          else
            array << { str: item[key], attr: "" }
          end
        }
        array
      }
    end
  end
end
