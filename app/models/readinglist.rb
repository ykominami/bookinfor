class Readinglist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :shape

  default_scope { order("date DESC") }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "register_date", "date", 
    "title", "status", "shape_id", "isbn", "readstatus_id",  
    "created_at", "updated_at", ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category_id", "created_at", "date", "id", "isbn", "readstatus_id", "register_date", "shape", "status", "title", "updated_at"]
  end
end
