class PairScoreCalculator
  GOAL_COMPATIBILITY = {
    "lose_weight" => %w[improve_endurance general_fitness],
    "gain_muscle" => %w[compete general_fitness],
    "improve_endurance" => %w[lose_weight compete general_fitness],
    "general_fitness" => %w[lose_weight gain_muscle improve_endurance rehabilitate],
    "compete" => %w[gain_muscle improve_endurance],
    "rehabilitate" => %w[general_fitness]
  }.freeze

  EXPERIENCES = %w[beginner intermediate advanced].freeze

  def initialize(profile, other)
    @profile = profile
    @other = other
  end

  def call
    goal_score + experience_score + age_score + gender_score
  end

  private

  def goal_score
    return 40 if @profile.goal == @other.goal
    return 20 if GOAL_COMPATIBILITY[@profile.goal]&.include?(@other.goal)

    0
  end

  def experience_score
    diff = (EXPERIENCES.index(@profile.experience).to_i - EXPERIENCES.index(@other.experience).to_i).abs
    case diff
    when 0 then 30
    when 1 then 15
    else 0
    end
  end

  def age_score
    return 0 if @profile.birthdate.nil? || @other.birthdate.nil?

    diff = (@profile.birthdate - @other.birthdate).abs.to_f / 365.25
    if    diff <= 2  then 20
    elsif diff <= 5  then 15
    elsif diff <= 10 then 10
    elsif diff <= 15 then 5
    else 0
    end
  end

  def gender_score
    @profile.gender == @other.gender ? 10 : 0
  end
end
