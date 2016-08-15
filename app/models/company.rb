class Company < ActiveRecord::Base
  acts_as_paranoid
  has_many :users
  has_many :residents, dependent: :destroy

  validates :name, :company_code, presence: true
end
