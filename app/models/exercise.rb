class Exercise < ApplicationRecord
  validates :title, presence: true, uniqueness: true

  validates :difficulty,
            inclusion: {
              in: %w[Beginner Intermediate Advanced],
              message: "%{ value } is not a valid difficulty"
            }
end
