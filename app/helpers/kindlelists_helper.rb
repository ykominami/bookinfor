module KindlelistsHelper
  class Kindlelistx
    attr_reader :header, :body, :name

    def initialize(name, kindlelists, view_context)
      @logger = LoggerUtils.logger

      @name = name
      @kindlelists = kindlelists
      @view_context = view_context
      # @keys = %i(asin title publisher author publish_date purchase_date read_status category)
      # @keys = %i(read_status category title publisher author publish_date asin)
      @keys = %i[read_status category title]
      key_header = { read_status: "re" }
      @header = @keys.map do |key|
        value = key_header[key]
        # @logger.debug value
        value || key.to_s
      end
      @body = @kindlelists.map do |item|
        array = []
        @logger.debug item
        @keys.each_with_index do |key, index|
          item[key] = 0 if key == :read_status && item[key].nil?

          case index
          when 0
            array << { str: item.readstatus.name, attr: 20 }
          when 1
            array << { str: item.category.name, attr: 100 }
          when 2
            array << { str: item[key], attr: 400 }
          when 3
            array << { str: item[key], attr: 100 }
          when 4
            array << { str: item[key], attr: 200 }
          else
            array << { str: item[key], attr: "" }
          end
        end
        array
      end
      @logger.debug @body
    end
  end
end
