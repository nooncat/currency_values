class RateChannel < ApplicationCable::Channel
  def subscribed
    if params[:rate_id]
      rate = Rate.find(params[:rate_id])
      stream_for rate
    else
      reject
    end
  end

  def unsubscripbed; end
end
