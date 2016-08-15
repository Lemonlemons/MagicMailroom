class User < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :company
  has_many :deliveries

  validates :firstname, :lastname, :email, :encrypted_password, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
end
