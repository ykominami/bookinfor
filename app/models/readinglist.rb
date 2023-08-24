class Readinglist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :shape

  default_scope { order("date DESC") }

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "date", "id", "isbn", "readstatus_id", "register_date", "shape", "status", "title", "updated_at", "shape_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["readstatus", "shape"]
  end
end
