class Pairing < ApplicationRecord
  belongs_to :user1, class_name: "User", foreign_key: :user_id_1
  belongs_to :user2, class_name: "User", foreign_key: :user_id_2
  has_one :chat, as: :chattable, dependent: :destroy
  has_many :workout_plans, dependent: :destroy
  has_one :direct_chat, dependent: :destroy

  validates :user_id_1, uniqueness: { scope: :user_id_2 }

  after_create { create_chat! }

  def partner_for(user)
    user.id == user_id_1 ? user2 : user1
  end
end
