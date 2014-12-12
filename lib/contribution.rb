class Contribution < ActiveRecord::Base
  belongs_to :employee
  belongs_to :big_deal
end