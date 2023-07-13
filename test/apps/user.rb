class User
  include ActiveModel::Model

  attr_accessor :name, :email, :description, :phone, :dob, :lunch_time,
    :confirmed_at, :birth_month, :birthday_week, :favorite_url, :age,
    :years_of_experience, :password
end
