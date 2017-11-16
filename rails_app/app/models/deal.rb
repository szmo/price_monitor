class Deal < ApplicationRecord

  has_many :user_deals
  has_many :users, through: :user_deals

  validates :name, presence: true
  validates :price, presence: true
  validates :url, presence: true, uniqueness: true
end
