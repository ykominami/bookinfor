class Efg < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "zid", "s", "updated_at"]
  end
end
