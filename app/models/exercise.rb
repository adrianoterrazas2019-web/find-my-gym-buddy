class Exercise < ApplicationRecord
  validates :difficulty, inclusion: { in: %w(Beginner Intermediate Advanced), # rubocop:disable Style/PercentLiteralDelimiters
                                  message: "%{value} is not a valid difficulty" } # rubocop:disable Style/FormatStringToken
end
