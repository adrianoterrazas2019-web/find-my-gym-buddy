class CalendarEntriesController < ApplicationController
  def show
    @calendar_entry = current_user.calendar.calendar_entries.find(params[:id])
  end

  def new
    calendar = current_user.calendar || current_user.create_calendar
    @calendar_entry = calendar.calendar_entries.new
  end

  def create
    calendar = current_user.calendar || current_user.create_calendar
    @calendar_entry = calendar.calendar_entries.new(calendar_entry_params)

    if @calendar_entry.save
      redirect_to calendars_path, notice: "Entry added."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @calendar_entry = CalendarEntry.find(params[:id])
  end

  def update
    @calendar_entry = current_user.calendar.calendar_entries.find(params[:id])

    if @calendar_entry.update(calendar_entry_params)
      redirect_to calendar_entry_path(@calendar_entry), notice: "Entry updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @calendar_entry = current_user.calendar.calendar_entries.find(params[:id])
    @calendar_entry.destroy

    redirect_to calendars_path, notice: "Entry deleted.", status: :see_other
  end

  private

  def calendar_entry_params
    params.require(:calendar_entry).permit(:start_time, :end_time, :title, :location, :entry_type, :note)
  end
end
