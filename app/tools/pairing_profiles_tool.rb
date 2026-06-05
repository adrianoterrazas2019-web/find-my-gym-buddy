class PairingProfilesTool < RubyLLM::Tool
  description "Fetch the user profiles of both users in this pairing"

  def initialize(pairing)
    @pairing = pairing
  end

  def execute
    [@pairing.user1, @pairing.user2].map do |user|
      profile = user.user_profile
      next { error: "no profile" } unless profile

      {
        name: profile.name,
        age: ((Date.today - profile.birthdate) / 365.25).to_i,
        gender: profile.gender,
        goal: profile.goal,
        experience: profile.experience,
        location: profile.address
      }
    end
  end
end
