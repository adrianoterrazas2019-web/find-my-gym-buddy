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
        # Respond with a Turbo Stream that removes this card and appends a
        # hidden form. auto_submit_controller fires its connect() hook the
        # moment the form enters the DOM, triggering POST /pairings as a
        # separate HTTP action so PairingsController#create owns the pairing.
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: [
              turbo_stream.remove("request_#{@request.id}"),
              turbo_stream.append("requests_list",
                helpers.tag.form(
                  action: pairings_path,
                  method: :post,
                  data: { controller: "auto-submit", turbo: false }
                ) do
                  helpers.hidden_field_tag(:request_id, @request.id) +
                  helpers.hidden_field_tag(:authenticity_token, helpers.form_authenticity_token)
                end
              )
            ]
          end
          format.html { redirect_to requests_path, notice: "Request accepted." }
        end
      else
        redirect_to requests_path, notice: "Request denied."
      end
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
