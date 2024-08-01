module CalibrelistsHelper
  class Calibrelistx
    attr_reader :header, :body, :name

    def initialize(name, calibrelists)
      @name = name
      @calibrelists = calibrelists
      # @keys = %i(title authors timestamp tags publisher languages)
      @keys = %i[read_status category title authors tags publisher]
      key_header = { :read_status => "re" }
      @header = @keys.map { |key| key_header[key] || key.to_s }
      # @header = %W(read category title authors tags publisher)

      @body = @calibrelists.map do |item|
        array = []
        @keys.each_with_index do |key, index|
          case index
          when 0 | 1 | 3 | 4 | 5
            array << { str: item[key], attr: 50 }
          when 2
            array << { str: item[key], attr: 100 }
          else
            array << { str: item[key], attr: "" }
          end
        end
        array
      end
    end
  end
end
