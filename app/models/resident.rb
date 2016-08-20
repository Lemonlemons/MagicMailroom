class Resident < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :company, :counter_cache => true
  has_many :deliveries, dependent: :destroy

  validates :company_id, :name, :apartment_number, :email, presence: true
  validates_format_of :email, with: Devise::email_regexp
end
