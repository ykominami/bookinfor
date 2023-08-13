module KindlelistsHelper
  class Kindlelistx
    attr_reader :header, :body, :name

    def initialize(name, kindlelists, view_context)
      @name = name
      @kindlelists = kindlelists
      @view_context = view_context
      # @keys = %i(asin title publisher author publish_date purchase_date read_status category)
      # @keys = %i(read_status category title publisher author publish_date asin)
      @keys = %i(read_status category title)
      key_header = { read_status: "re" }
      @header = @keys.map { |key|
        value = key_header[key]
        # p value
        value ? value : key.to_s
      }
      @body = @kindlelists.map { |item|
        array = []
        p item
        @keys.each_with_index { |key, index|
          # p key.class
          # if key == :read_status
          if key == :read_status
            # item[key] = render_to_string LinkButttonComponent.new(label: "finish", url: "/abc")
            item[key] = 0 unless item[key]
            # item[key] = LinkButtonComponent.new(label: "#{key}", url: "/abc").render_in(@view_context)
          else
            # item[key] = key.size
          end

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
        }
        array
      }
      p @body
    end
  end
end
