class Kindlelist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :category

  default_scope { order("purchase_date DESC") }
  def self.ransackable_attributes(auth_object = nil)
    ["asin", "author", "category", "category_id", "created_at", "id", "publish_date",
     "publisher", "purchase_date", "read_status", "readstatus_id", "title", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "readstatus"]
  end
end
