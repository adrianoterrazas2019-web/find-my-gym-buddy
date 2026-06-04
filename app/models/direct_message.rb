class DirectMessage < ApplicationRecord
  belongs_to :direct_chat
  belongs_to :user

  validates :content, presence: true
end
