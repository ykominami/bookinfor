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
      @keys = %i(id read_status category title author purchase_date asin)
      key_header = { read_status: "re" }
      @header = @keys.map do |key|
        value = key_header[key]
        # @logger.debug value
        value || key.to_s
      end
      @body = @kindlelists.map do |item|
        array = []
        p item
        # array << { str: (render_to_string html: kindlelist_path), attr: 100 }
        # array << { str: "", attr: 100 }
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

          case key
          when :id
            array << { str: item[key], attr: 20 }
          when :read_status
            array << { str: item.readstatus.name, attr: 60 }
          when :category
            array << { str: item.category.name, attr: 100 }
          when :title
            array << { str: item[key], attr: 400 }
          when :author
            array << { str: item[key], attr: 200 }
          when :purchase_date
            array << { str: item[key], attr: 100 }
          else
            # :asin
            array << { str: item[key], attr: "" }
          end
=begin
          case index
          when 0
            array << { str: item[key], attr: 20 }
          when 1
            array << { str: item.readstatus.name, attr: 20 }
          when 2
            array << { str: item.category.name, attr: 100 }
          when 3
            array << { str: item[key], attr: 400 }
          when 4
            array << { str: item[key], attr: 400 }
          when 4
            array << { str: item[key], attr: 200 }
          when 5
            array << { str: item[key], attr: 100 }
          else
            array << { str: item[key], attr: "" }
          end
=end
        }
        array
      end
      @logger.debug @body
    end
  end
end
