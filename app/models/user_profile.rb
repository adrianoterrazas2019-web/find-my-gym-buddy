class UserProfile < ApplicationRecord
  GENDERS = %w[male female non-binary other].freeze
  GOALS = %w[lose_weight gain_muscle improve_endurance general_fitness compete rehabilitate].freeze
  EXPERIENCES = %w[beginner intermediate advanced].freeze

  GOAL_COMPATIBILITY = {
    "lose_weight"       => %w[improve_endurance general_fitness],
    "gain_muscle"       => %w[compete general_fitness],
    "improve_endurance" => %w[lose_weight compete general_fitness],
    "general_fitness"   => %w[lose_weight gain_muscle improve_endurance rehabilitate],
    "compete"           => %w[gain_muscle improve_endurance],
    "rehabilitate"      => %w[general_fitness]
  }.freeze

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

  def pair_score_with(other)
    goal_score(other) + experience_score(other) + age_score(other) + gender_score(other)
  end

  private

  def goal_score(other)
    return 40 if goal == other.goal
    return 20 if GOAL_COMPATIBILITY[goal]&.include?(other.goal)
    0
  end

  def experience_score(other)
    diff = (EXPERIENCES.index(experience).to_i - EXPERIENCES.index(other.experience).to_i).abs
    case diff
    when 0 then 30
    when 1 then 15
    else 0
    end
  end

  def age_score(other)
    return 0 if birthdate.nil? || other.birthdate.nil?
    diff = (birthdate - other.birthdate).abs.to_f / 365.25
    if    diff <= 2  then 20
    elsif diff <= 5  then 15
    elsif diff <= 10 then 10
    elsif diff <= 15 then 5
    else 0
    end
  end

  def gender_score(other)
    gender == other.gender ? 10 : 0
  end
end
