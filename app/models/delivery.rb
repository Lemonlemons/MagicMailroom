class Delivery < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :resident
  belongs_to :user
end
