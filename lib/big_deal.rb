class BigDeal < ActiveRecord::Base
  has_many :contributions
  has_many :employees, through: :contributions
end