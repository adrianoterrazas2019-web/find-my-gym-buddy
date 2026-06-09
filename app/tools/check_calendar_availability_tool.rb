class CheckCalendarAvailabilityTool < RubyLLM::Tool
  description "Fetches both users' upcoming calendar entries so you can answer availability questions. " \
              "Call this when the user asks about free slots, scheduling conflicts, or shared availability."

  param :days_ahead, type: :integer, desc: "How many days ahead to look (e.g. 7 for this week, 30 for this month)"

  def initialize(pairing:)
    @pairing = pairing
  end

  def execute(days_ahead:)
    Rails.logger.info("[CheckCalendarAvailabilityTool] Executing pairing_id=#{@pairing.id} days_ahead=#{days_ahead}")

    window_end = Time.current + days_ahead.days

    lines = [@pairing.user1, @pairing.user2].map.with_index(1) do |user, i|
      name = user.user_profile&.name || "User #{i}"
      entries = user.calendar&.calendar_entries
                              &.where(start_time: Time.current..window_end)
                              &.order(:start_time) || []

      entry_lines = entries.map { |e| "  - #{e.title}: #{e.start_time.iso8601} to #{e.end_time.iso8601}" }.join("\n")
      "#{name}'s calendar (next #{days_ahead} days):\n#{entry_lines.presence || '  (no entries)'}"
    end.join("\n\n")

    "Today is #{Time.current.iso8601}.\n\n#{lines}"
  rescue => e
    Rails.logger.error("[CheckCalendarAvailabilityTool] Failed pairing_id=#{@pairing.id}: #{e.class}: #{e.message}\n#{e.backtrace&.first(10)&.join("\n")}")
    "Error fetching calendar: #{e.message}"
  end
end
