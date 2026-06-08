class CalendarsController < ApplicationController
  def index
    calendar = current_user.calendar
    @calendar_entries = calendar ? calendar.calendar_entries.order(:start_time) : []
  end
end
