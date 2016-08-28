class User < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :company, :counter_cache => true
  has_many :deliveries

  validates :firstname, :lastname, :email, :encrypted_password, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :invitable

  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end
end
