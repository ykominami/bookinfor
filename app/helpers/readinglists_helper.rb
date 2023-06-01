module ReadinglistsHelper
    class Reainglistx
        attr_reader :header, :body, :name

        def initialize(name , readinglists)
            @name = name
            @readinglists = readinglists
            @keys = %i(register_date date title status shape isbn)
            @header = @keys.map{ |key| key.to_s }
            @body = @readinglists.map{ |item| 
                @keys.map{ |key| item[key] }        
            }
        end
    end
end
