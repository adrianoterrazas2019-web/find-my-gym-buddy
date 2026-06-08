class UserProfile < ApplicationRecord
  include PgSearch::Model

  GENDERS    = %w[male female non-binary other].freeze
  GOALS      = %w[lose_weight gain_muscle improve_endurance general_fitness compete rehabilitate].freeze
  EXPERIENCES = %w[beginner intermediate advanced].freeze

  belongs_to :user
  has_one_attached :photo

  # Full-text + trigram search across name (A=high weight) and address (B=lower weight)
  pg_search_scope :search_profiles,
    against: { name: "A", address: "B" },
    using: {
      tsearch: { prefix: true, any_word: true },
      trigram: { threshold: 0.1 }
    }

  validates :name, :birthdate, :gender, presence: true
  validates :name, length: { minimum: 2 }
  validates :birthdate, comparison: { less_than_or_equal_to: 18.years.ago,
                                      message: "You need to be 18 or older" }
  validates :gender, inclusion: { in: GENDERS,
                                  message: "%{value} is not a valid gender" } # rubocop:disable Style/FormatStringToken
  validates :goal, inclusion: { in: GOALS,
                                message: "%{value} is not a valid goal" }, # rubocop:disable Style/FormatStringToken
                  allow_blank: true
  validates :experience, inclusion: { in: EXPERIENCES,
                                      message: "%{value} is not a valid experience" }, # rubocop:disable Style/FormatStringToken
                         allow_blank: true

  scope :filter_by, ->(params) {
    results = all

    # Full-text search across name and address (replaces plain ILIKE)
    results = results.search_profiles(params[:search]) if params[:search].present?

    # Goals supports multiple selection — params[:goals] is an array
    results = results.where(goal: params[:goals]) if params[:goals].present?

    results = results.where(experience: params[:experience]) if params[:experience].present?
    results = results.where(gender: params[:gender])         if params[:gender].present?

    results
  }
end
