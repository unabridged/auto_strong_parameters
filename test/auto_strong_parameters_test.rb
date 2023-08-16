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
end
