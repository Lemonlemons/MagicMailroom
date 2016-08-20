class Delivery < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :resident, :counter_cache => true
  belongs_to :user, :counter_cache => true
end
