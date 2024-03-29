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
        <%= f.select :location, [['Home',1], ['Work', 2]] %>
        <%= f.radio_button :preferred_phone_os, :iphone %>
        <%= f.radio_button :preferred_phone_os, :android %>
        <%= f.fields_for :parents do |parf| %>
          <%= parf.text_field :name %>
          <%= parf.text_area :job %>
        <% end %>
        <%= f.fields_for :pet do |petf| %>
          <%= petf.text_field :nickname %>
          <%= petf.number_field :age %>
        <% end %>
      <% end %>
    NEW_USER_FORM
  )]

  def new
    @user = User.new
  end

  def auto_permit
    u = params.auto_permit!(:user)
    render json: u
  end

  def unpermitted
    u = params.require(:user).permit(:name, pets: [:kind])
    render json: u
  end
end
