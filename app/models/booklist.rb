class Booklist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :category
  belongs_to :shape
  belongs_to :bookstore

  validates :title, presence: true

  validates :xid, presence: true
  def self.ransackable_attributes(auth_object = nil)
    ["id",  "asin", "bookstore_id", "category_id", 
    "totalID", "xid", "purchase_date", "title",  
    "readstatus_id", "shape_id", 
    "created_at",  "updated_at",
    ]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category_id", "readstatus_id", "bookstore_id"]
  end
end
