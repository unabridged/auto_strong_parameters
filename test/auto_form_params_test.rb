# frozen_string_literal: true

require 'test_helper'

class AutoFormParamsTest < ActionController::TestCase
  setup do
    @controller = BasicController.new
  end

  def signature
    AutoStrongParameters.verifier.generate(permitted_keys)
  end

  def permitted_keys
    %w(
      name email description phone dob lunch_time confirmed_at birth_month
      birthday_week favorite_url age years_of_experience password
    ) + [{"pets_attributes" => ['name']}]
  end

  def test_new
    get :new
    assert_response :ok
    puts response.body

    assert_select "form[id='new_user']"
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']" do
      assert_select "[value=?]", signature
    end
  end
end
