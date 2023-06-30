# frozen_string_literal: true

require 'test_helper'

class FormTest < ActionController::TestCase
  setup do
    @controller = BasicController.new
  end

  def test_unpermitted
    post :unpermitted, user: { test: 1, allowed: 2 }
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_equal '2', j['allowed']
    assert_nil j['test']
  end

  def test_auto_permit
    post :auto_permit, user: { test: 1, allowed: 2 }
    assert_response :ok
    j = ActiveSupport::JSON.decode(response.body)

    assert_equal '2', j['allowed']
    assert_equal '1', j['test']
  end
end
