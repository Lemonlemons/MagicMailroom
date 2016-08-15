class Resident < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :company
  has_many :deliveries, dependent: :destroy

  validates :company_id, :name, :apartment_number, :email, presence: true
end
