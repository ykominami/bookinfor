module BooklistsHelper
    class Booklistx
        attr_reader :header, :body, :name

        def initialize(name , booklists)
            @name = name
            @booklists = booklists
            # @keys = %i(totalID xid purchase_date bookstore title asin read_status shape category)
            @keys = %i(totalID purchase_date title asin read_status shape category)
            @header = @keys.map{ |key| key.to_s }
            @body = @booklists.map{ |item| 
                @keys.map{ |key| item[key] }        
            }
        end
    end
end
