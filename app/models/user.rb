class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  has_one :user_profile, dependent: :destroy

  accepts_nested_attributes_for :user_profile
end
