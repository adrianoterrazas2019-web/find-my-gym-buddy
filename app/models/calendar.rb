class Calendar < ApplicationRecord
  belongs_to :user
  has_many :calendar_entries, dependent: :destroy 
end
