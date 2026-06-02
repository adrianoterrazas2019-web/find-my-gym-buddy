class Request < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  enum :status, { pending: "pending", accepted: "accepted", denied: "denied" }

  validates :status, presence: true
  validate :sender_and_recipient_must_differ

  private

  def sender_and_recipient_must_differ
    errors.add(:recipient_id, "must be different from sender") if sender_id == recipient_id
  end
end
