class Booklist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :category
  belongs_to :shape
  belongs_to :bookstore

  validates :title, presence: true

  validates :xid, presence: true
  def self.ransackable_attributes(auth_object = nil)
    ["asin", "bookstore", "category", "created_at", "id", "purchase_date", "read_status",
     "shape_id", "title", "totalID", "updated_at", "xid", "readstatus_id", "category_id", "bookstore_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category", "readstatus", "bookstore"]
  end
end
