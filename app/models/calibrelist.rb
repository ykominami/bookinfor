class Calibrelist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :category

  default_scope { order("timestamp DESC") }

  validates :title, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["xid", "xxid", "isbn",
     "zid", "uuid", "comments", "size", "series", "series_index",
     "title", "title_sort", "tags", "library_name", "formats",
     "timestamp", "pubdate", "publisher", "authors", "author_sort",
     "languages", "readstatus_id", "category_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["category_id", "readstatus_id"]
  end
end
