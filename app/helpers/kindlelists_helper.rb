module KindlelistsHelper
    class Kindlelistx
        attr_reader :header, :body, :name

        def initialize(name , kindlelists)
            @name = name
            @kindlelists = kindlelists
            @keys = %i(asin title  publisher author publish_date purchase_date read_status category)
            @header = @keys.map{ |key| key.to_s }
            @body = @kindlelists.map{ |item| 
                @keys.map{ |key| item[key] }        
            }
        end
    end
end
