class CalendarsController < ApplicationController
  def index
    @calendar_entries = CalendarEntry.all
  end
end
