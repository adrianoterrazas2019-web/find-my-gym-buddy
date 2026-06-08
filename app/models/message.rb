class Message < ApplicationRecord
  acts_as_message
  belongs_to :user, optional: true

  scope :visible, -> { where(role: %w[user assistant]).where.not(id: joins(:tool_calls).select(:id)) }
  has_many_attached :attachments

  after_create_commit -> { broadcast_append_to "chat_#{chat_id}" }, if: :visible?
  after_update_commit -> { broadcast_replace_to "chat_#{chat_id}" }, if: :visible?
  after_update_commit -> { broadcast_remove_to "chat_#{chat_id}" }, unless: :visible?

  def visible?
    role == 'user' || (role == 'assistant' && !tool_call?)
  end

  def broadcast_append_chunk(content)
    broadcast_append_to "chat_#{chat_id}",
                        target: "message_#{id}_content",
                        html: ERB::Util.html_escape(content.to_s)
  end
end
