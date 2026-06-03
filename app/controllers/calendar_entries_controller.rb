class CalendarEntriesController < ApplicationController
  def new
    @calendar_entry = CalendarEntry.new
  end

  def create
    @calendar_entry = CalendarEntry.new(calendar_entry_params)
    @calendar_entry.save
    redirect_to root_path
  end

  def edit
    @calendar_entry = CalendarEntry.find(params[:id])
  end

  def update
    @calendar_entry = CalendarEntry.find(params[:id])
    @calendar_entry.update(calendar_entry_params)
    redirect_to root_path
  end

  def destroy
    @calendar_entry = CalendarEntry.find(params[:id])
    @calendar_entry.destroy
    redirect_to root_path
  end

  private

  def calendar_entry_params
    params.require(:calendar_entry).permit(:calendar_id, :datetime, :title, :location, :entry_type, :note)
  end
end
