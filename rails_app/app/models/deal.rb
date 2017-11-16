class Deal < ApplicationRecord
  validates :name, presence: true
  validates :price, presence: true
  validates :url, presence: true
end
