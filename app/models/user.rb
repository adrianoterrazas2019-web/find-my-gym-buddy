class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  has_one :calendar, dependent: :destroy
  has_one :user_profile, dependent: :destroy

  after_create :create_calendar

  has_many :sent_requests, class_name: "Request", foreign_key: :sender_id, dependent: :destroy
  has_many :received_requests, class_name: "Request", foreign_key: :recipient_id, dependent: :destroy
  has_many :pairings_as_user1, class_name: "Pairing", foreign_key: :user_id_1, dependent: :destroy
  has_many :pairings_as_user2, class_name: "Pairing", foreign_key: :user_id_2, dependent: :destroy

  def pairings
    Pairing.where(user_id_1: id).or(Pairing.where(user_id_2: id))
  end
  
  accepts_nested_attributes_for :user_profile
end
