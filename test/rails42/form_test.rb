# frozen_string_literal: true

require 'test_helper'

class FormTest < ActionController::TestCase
  setup do
    @controller = WelcomeController.new
  end

  def test_true
    post :update, user: { test: 1 }
    assert_response :ok
  end
end
