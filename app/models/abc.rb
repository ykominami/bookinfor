class Abc < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["zid", "s"]
  end
end
