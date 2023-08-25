class Category < ApplicationRecord
  has_many :kindlelists
  has_many :booklists
  has_many :booklistlooses
  has_many :booklisttights
  has_many :readinglists

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "name", "sort_a_key", "sort_b_key", "sort_c_key", "updated_at"]
  end
end
