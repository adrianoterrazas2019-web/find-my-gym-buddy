class UserProfile < ApplicationRecord
  GENDERS = %w[male female non-binary other].freeze
  GOALS = %w[lose_weight gain_muscle improve_endurance general_fitness compete rehabilitate].freeze
  EXPERIENCES = %w[beginner intermediate advanced].freeze

  belongs_to :user
  has_one_attached :photo

  validates :name, :birthdate, :gender, presence: true
  validates :name, length: { minimum: 2 }
  validates :birthdate, comparison: { less_than_or_equal_to: 18.years.ago,
                                      message: "You need to be 18 or older" }
  validates :gender, inclusion: { in: GENDERS,
                                  message: "%{value} is not a valid gender" } # rubocop:disable Style/FormatStringToken
validates :goal, inclusion: { in: GOALS,
                                  message: "%{value} is not a valid goal" } # rubocop:disable Style/FormatStringToken
validates :experience, inclusion: { in: EXPERIENCES,
                                  message: "%{value} is not a valid experience" } # rubocop:disable Style/FormatStringToken                                  
  scope :filter_by, ->(params) {
    results = all
    results = results.where("address ILIKE ?", "%#{params[:location]}%") if params[:location].present?
    results = results.where(goal: params[:goal])                         if params[:goal].present?
    results = results.where(experience: params[:experience])             if params[:experience].present?
    results = results.where(gender: params[:gender])                     if params[:gender].present?
    if params[:date].present?
      results = results.joins(user: { calendar: :calendar_entries })
                       .where("calendar_entries.start_time::date = ?", params[:date])
                       .distinct
    end
    results
  }
end
