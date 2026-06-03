class UserProfile < ApplicationRecord
  GENDERS = %w[male female non-binary other].freeze

  belongs_to :user

  validates :name, :birthdate, :gender, presence: true
  validates :name, length: { minimum: 2 }
  validates :birthdate, comparison: { less_than_or_equal_to: 18.years.ago,
                                      message: "You need to be 18 or older" }
  validates :gender, inclusion: { in: GENDERS,
                                  message: "%{value} is not a valid gender" } # rubocop:disable Style/FormatStringToken
end
