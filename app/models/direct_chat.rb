class DirectChat < ApplicationRecord
  belongs_to :pairing
  has_many :direct_messages, dependent: :destroy
end
