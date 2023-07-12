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
    %w(name email)
  end

  def test_new
    get :new
    assert_response :ok
    puts response.body

    assert_select "form[id='new_user']"
    assert_select "form[id='new_user'] input[name='_asp_params']" do
      assert_select "[value]"
    end
  end
end
