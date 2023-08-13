class Calibrelist < ApplicationRecord
  belongs_to :readstatus
  belongs_to :category

  default_scope { order("timestamp DESC") }
end
