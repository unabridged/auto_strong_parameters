class BasicController < ActionController::Base
  include Rails.application.routes.url_helpers

  def auto_permit
    u = params.require(:user).auto_permit!
    render json: u
  end

  def unpermitted
    u = params.require(:user).permit(:name, pets: [:kind])
    render json: u
  end
end
