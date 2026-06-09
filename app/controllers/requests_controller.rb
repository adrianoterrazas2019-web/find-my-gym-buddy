class RequestsController < ApplicationController
  before_action :set_request, only: [:update]

  def index
    @requests = current_user.received_requests.pending
  end

  def create
    @request = Request.new(sender: current_user, recipient_id: params[:user_id])
    if @request.save
      redirect_to requests_path, notice: "Request sent."
    else
      redirect_to root_path, alert: @request.errors.full_messages.join(", ")
    end
  end

  def update
    return redirect_to requests_path, alert: "Invalid status." unless request_params[:status] == "denied"

    if @request.update(status: :denied)
      redirect_to requests_path, notice: "Request denied."
    else
      redirect_to requests_path, alert: "Something went wrong."
    end
  end

  private

  def set_request
    @request = current_user.received_requests.find(params[:id])
  end

  def request_params
    params.require(:request).permit(:status)
  end
end
