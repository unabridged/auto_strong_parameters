class BasicController < ActionController::Base
  include Rails.application.routes.url_helpers

  self.view_paths = [ActionView::FixtureResolver.new(
    "basic/new.html.erb" => <<~NEW_USER_FORM
      <%= form_for @user, url: "/auto_permit" do |f| %>
        Name: <%= f.text_field :name %>
        Email: <%= f.email_field :email %>
      <% end %>
    NEW_USER_FORM
  )]

  def new
    @user = User.new
  end

  def auto_permit
    u = params.require(:user).auto_permit!
    render json: u
  end

  def unpermitted
    u = params.require(:user).permit(:name, pets: [:kind])
    render json: u
  end
end
