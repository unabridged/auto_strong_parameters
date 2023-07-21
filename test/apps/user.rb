class User
  include ActiveModel::Model

  attr_accessor :name, :email, :description, :phone, :dob, :lunch_time,
    :confirmed_at, :birth_month, :birthday_week, :favorite_url, :age,
    :years_of_experience, :password

  def parents
    @parents ||= [Parent.new]
  end

  def parents_attributes=(val)
    @parents = Array.wrap(val)
  end

  def pet
    @pet ||= Pet.new
  end

  def pet_attributes=(val)
    @pet = val
  end
end
