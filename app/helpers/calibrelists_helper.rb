module CalibrelistsHelper
    class Calibrelistx
        attr_reader :header, :body, :name

        def initialize(name , calibrelists)
            @name = name
            @calibrelists = calibrelists
            @keys = %i(xid read_status category title title_sort tags xxid uuid isbn zid comments size series series_index
                       library_name formats timestamp pubdate publisher authors author_sort languages 
                       rating identifiers)
        
            @header = @keys.map{ |key| key.to_s }
            @body = @calibrelists.map{ |item| 
                @keys.map{ |key| item[key] }        
            }
        end
    end
end
