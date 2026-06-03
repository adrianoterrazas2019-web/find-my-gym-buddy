class Message < ApplicationRecord
  acts_as_message
  belongs_to :user, optional: true
  has_many_attached :attachments

  broadcasts_to ->(message) { "chat_#{message.chat_id}" }, inserts_by: :append

  before_create :assign_user_from_current

  private

  def assign_user_from_current
    self.user ||= Current.user if role == "user"
  end

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
      target: "message_#{id}_content",
      content: ERB::Util.html_escape(content.to_s)
  end
end
