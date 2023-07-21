class BasicController < ActionController::Base
  include Rails.application.routes.url_helpers

  self.view_paths = [ActionView::FixtureResolver.new(
    "basic/new.html.erb" => <<~NEW_USER_FORM
      <%= form_for @user, url: "/auto_permit" do |f| %>
        <%= f.text_field :name %>
        <%= email_field :user, :email %>
        <%= f.text_area :description %>
        <%= f.telephone_field :phone %>
        <%= f.date_field :dob %>
        <%= f.time_field :lunch_time %>
        <%= f.datetime_field :confirmed_at %>
        <%= f.month_field :birth_month %>
        <%= f.week_field :birthday_week %>
        <%= f.url_field :favorite_url %>
        <%= f.number_field :age %>
        <%= f.range_field :years_of_experience %>
        <%= f.password_field :password %>
        <%= f.fields_for :parents do |parf| %>
          <%= parf.text_field :name %>
        <% end %>
        <%= f.fields_for :pet do |petf| %>
          <%= petf.text_field :name %>
        <% end %>
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
