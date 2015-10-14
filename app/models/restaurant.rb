class Restaurant < ActiveRecord::Base

  has_many :reviews, dependent: :destroy
  has_one :user
  validates :name, length: {minimum: 3}, uniqueness: true

end
