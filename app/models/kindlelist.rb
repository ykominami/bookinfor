class Kindlelist < ApplicationRecord
  belongs_to :readstatus, dependent: :destroy
  belongs_to :category, dependent: :destroy
  belongs_to :shape, dependent: :destroy

  default_scope { order("purchase_date DESC") }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "asin", "author", "category_id", "title", "publisher", "readstatus_id", "shape_id",
      "publish_date", "purchase_date", 
    "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category_id", "readstatus_id", "shape_id"]
  end
end
