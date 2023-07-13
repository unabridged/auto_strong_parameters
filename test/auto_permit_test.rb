# frozen_string_literal: true

require 'test_helper'

class AutoPermitTest < ActionController::TestCase
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

  def message_key
    AutoStrongParameters.asp_message_key
  end

  def permitted_keys
    ['name', 'age', { 'pets' => ['name', 'kind'] }]
  end

  # Rails 4.2 does not have the keyword API for #process et al.
  def process_args(args)
    if defined? Rails42
      args
    else
      { params: args }
    end
  end

  def test_unpermitted
    post :unpermitted, **process_args(user: user_params)
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_equal 'John', j['name']
    assert_nil j['age']
    assert_nil j['pets'][0]['name']
    assert_equal 'dog', j['pets'][0]['kind']
  end

  def test_auto_permit
    post :auto_permit, **process_args(user: user_params.merge(message_key => signature))
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_equal 'John', j['name']
    assert_equal '30', j['age']
    assert_equal 'dog', j['pets'][0]['kind']
    assert_equal 'Fluffy', j['pets'][0]['name']
  end

  def test_auto_permit_incorrect_signature
    post :auto_permit, **process_args(user: user_params.merge(message_key => 'abc123'))
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_nil j['name']
    assert_nil j['age']
  end
end
