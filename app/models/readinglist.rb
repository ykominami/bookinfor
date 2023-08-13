class Readinglist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :category

  default_scope { order("date DESC") }
end
