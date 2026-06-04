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
    status = request_params[:status]
    return redirect_to requests_path, alert: "Invalid status." unless %w[accepted denied].include?(status)

    if @request.update(status: status)
      if @request.accepted?
        sender_profile = @request.sender.user_profile
        recipient_profile = @request.recipient.user_profile
        score = if sender_profile && recipient_profile
                  PairScoreCalculator.new(sender_profile, recipient_profile).call
                end
        Pairing.find_or_create_by!(
          user_id_1: @request.sender_id,
          user_id_2: @request.recipient_id
        ) { |p| p.pair_score = score }
      end
      redirect_to requests_path, notice: "Request #{@request.status}."
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
