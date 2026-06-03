class Chat < ApplicationRecord
  acts_as_chat
  belongs_to :chattable, polymorphic: true, optional: true
end
