# frozen_string_literal: true

require 'test_helper'

class AutoStrongParametersTest < Minitest::Test
  def to_strong_params_shape(h)
    AutoStrongParameters.to_strong_params_shape(h)
  end

  def test_to_strong_params_shape
    assert_equal ["name"], to_strong_params_shape({"name" => "Steve"})
    assert_equal ["name", "age"], to_strong_params_shape({"name" => "Steve", age: 5})
    assert_equal ["name", {"pet" => ["name"]}], to_strong_params_shape({"name" => "Steve", "pet" => { "name" => "Fluffy" }})
    assert_equal ["name", {"pet" => ["name"]}], to_strong_params_shape({"name" => "Steve", "pet" => { "name" => "Fluffy" }})
  end

  def test_nested_params
    params = {
      "user"=>{
        "first_name"=>"Steve",
        "last_name"=>"Sample",
        "email"=>"steve@example.com",
        "phone"=>"(123) 234-2345",
        "work_location"=>"Chicago",
        "birth_date"=>"1980-01-01",
      },
      "address"=>{
        "id"=>"7",
        "street_address"=>"123 Example St",
        "city"=>"Chicago",
        "state"=>"IL",
        "zip"=>"12345"
      },
      "emergency_contact"=>{
        "id"=>"16",
        "first_name"=>"Mary",
        "last_name"=>"Example",
        "phone"=>"(123) 123-1234",
      },
    }
    exp = {
      "user"=>[
        "first_name", "last_name", "email", "phone", "work_location", "birth_date"
      ],
      "address"=>[
        "id", "street_address", "city", "state", "zip"
      ],
      "emergency_contact"=>[
        "id", "first_name", "last_name", "phone"
      ],
    }
    actual = to_strong_params_shape(params)
    assert_equal exp["user"], actual["user"]
    assert_equal exp["address"], actual["address"]
    assert_equal exp["emergency_contact"], actual["emergency_contact"]
  end
end
