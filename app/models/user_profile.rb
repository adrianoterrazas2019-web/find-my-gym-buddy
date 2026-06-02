class UserProfile < ApplicationRecord
  belongs_to :user

  validates :name, :birthdate, :gender, presence: true
  validates :name, length: { minimum: 2 }
  validates :birthdate, comparison: { less_than_or_equal_to: 18.years.ago,
                                      message: "You need to be 18 or older" }
  validates :gender, inclusion: { in: %w(male female non-binary other), # rubocop:disable Style/PercentLiteralDelimiters
                                  message: "%{value} is not a valid gender" } # rubocop:disable Style/FormatStringToken
end
