class Kindlelist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :category

  default_scope { order("purchase_date DESC") }
end
