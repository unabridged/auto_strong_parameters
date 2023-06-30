# frozen_string_literal: true

require 'test_helper'

class FormTest < ActionController::TestCase
  setup do
    @controller = BasicController.new
  end

  def user_params
    {
      name: 'Drew',
      age: '22',
    }
  end

  def sign(arr)
    AutoStrongParameters.verifier.generate(arr)
  end

  def permitted_keys
    user_params.keys.map(&:to_s)
  end

  def test_unpermitted
    post :unpermitted, user: user_params
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_equal 'Drew', j['name']
    assert_nil j['age']
  end

  def test_auto_permit
    signature = sign(permitted_keys)

    post :auto_permit,
      user: user_params.merge(_asp_message: signature)
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_equal 'Drew', j['name']
    assert_equal '22', j['age']
  end

  def test_auto_permit_incorrect_signature
    signature = sign(permitted_keys)

    post :auto_permit,
      user: user_params.merge(_asp_message: 'abc123')
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_nil j['name']
    assert_nil j['age']
  end
end
