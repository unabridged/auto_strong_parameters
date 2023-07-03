# frozen_string_literal: true

require 'test_helper'

class FormTest < ActionController::TestCase
  setup do
    @controller = BasicController.new
  end

  def user_params
    {
      name: 'John',
      age: '30',
      pets: [
        { name: "Fluffy", kind: "dog" }
      ],
    }
  end

  def signature
    AutoStrongParameters.verifier.generate(permitted_keys)
  end

  def permitted_keys
    ['name', 'age', { 'pets' => ['name', 'kind'] }]
  end

  def test_unpermitted
    post :unpermitted, params: { user: user_params }
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_equal 'John', j['name']
    assert_nil j['age']
    assert_nil j['pets'][0]['name']
    assert_equal 'dog', j['pets'][0]['kind']
  end

  def test_auto_permit
    post :auto_permit, params: { user: user_params.merge(_asp_message: signature) }
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_equal 'John', j['name']
    assert_equal '30', j['age']
    assert_equal 'dog', j['pets'][0]['kind']
    assert_equal 'Fluffy', j['pets'][0]['name']
  end

  def test_auto_permit_incorrect_signature
    post :auto_permit, params: { user: user_params.merge(_asp_message: 'abc123') }
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_nil j['name']
    assert_nil j['age']
  end
end
