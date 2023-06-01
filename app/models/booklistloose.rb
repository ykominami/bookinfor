class Booklistloose < ApplicationRecord
    def self.ransackable_attributes(auth_object = nil)
         ["asin", "bookstore", "category", "created_at", "id", "purchase_date", "read_status", "shape", "title", "totalID", "updated_at", "xid"]
    end
    
end
