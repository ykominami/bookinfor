class Readinglist < ApplicationRecord
  belongs_to :shape
  # belongs_to :category
  belongs_to :readingstatus

  default_scope { order("date DESC") }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "register_date", "date", 
     "title", "readingstatus", "shape_id", "isbn", "readingstatus_id", 
     "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["id", "register_date", "category_id", "date",
     "title", "status", "shape_id", "isbn", "readingstatus_id", 
     "created_at", "updated_at"]
  end
end
