class Kindlelist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :category
  belongs_to :shape

  default_scope { order("purchase_date DESC") }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "asin", "author", "category_id", "title", "publisher", "readstatus_id", "shape_id",
      "publish_date", "purchase_date", 
    "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category_id", "readstatus_id", "shape_id"]
  def self.ransackable_associations(auth_object = nil)
    ["category", "readstatus", "shape"]
  end
end
