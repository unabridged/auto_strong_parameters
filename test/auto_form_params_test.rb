# frozen_string_literal: true

require 'test_helper'

class AutoFormParamsTest < ActionController::TestCase
  setup do
    @controller = BasicController.new
    @original_view_paths = BasicController.view_paths
  end

  teardown do
    # Restore original view paths
    BasicController.view_paths = @original_view_paths
  end

  def signature
    AutoStrongParameters.verifier.generate(permitted_keys)
  end

  def permitted_keys
    {
      "user" => [
        "name",
        "email",
        "description",
        "phone",
        "dob",
        "lunch_time",
        "confirmed_at",
        "birth_month",
        "birthday_week",
        "favorite_url",
        "age",
        "years_of_experience",
        "password",
        "location",
        "preferred_phone_os",
        {
          "parents_attributes"=>[
            "name",
            "job",
          ],
          "pet_attributes"=>[
            "nickname",
            "age",
          ],
        },
      ],
    }
  end

  def test_new
    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']" do
      assert_select "[value=?]", signature
    end
  end

  def test_form_with_malformed_field_does_not_crash
    # This test demonstrates the bug where _asp_track_field fails when regex doesn't match
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~MALFORMED_FORM
        <%= form_for @user, url: "/auto_permit" do |f| %>
          <%= f.text_field :name, name: nil %>
          <%= f.email_field :email %>
        <% end %>
      MALFORMED_FORM
    )]

    get :new
    assert_response :ok

    # Form should still render and include ASP hidden tag
    assert_select "form[id='new_user']"
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  def test_disabled_form_does_not_include_asp_hidden_tag
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~DISABLED_FORM
        <%= form_for @user, url: "/auto_permit", data: { asp_disabled: true } do |f| %>
          <%= f.text_field :name %>
          <%= f.email_field :email %>
        <% end %>
      DISABLED_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should NOT have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_globally_disabled_does_not_include_asp_hidden_tag
    # Temporarily disable globally
    AutoStrongParameters.enabled = false

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should NOT have the ASP hidden tag when globally disabled
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']", false

    # Re-enable for other tests
    AutoStrongParameters.enabled = true
  end

  def test_enabled_methods
    # Test default state
    assert AutoStrongParameters.enabled?
    refute AutoStrongParameters.disabled?

    # Test setting to false
    AutoStrongParameters.enabled = false
    refute AutoStrongParameters.enabled?
    assert AutoStrongParameters.disabled?

    # Test setting back to true
    AutoStrongParameters.enabled = true
    assert AutoStrongParameters.enabled?
    refute AutoStrongParameters.disabled?
  end

  def test_form_with_data_asp_disabled_attribute
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~DATA_DISABLED_FORM
        <%= form_for @user, url: "/auto_permit", data: { asp_disabled: "true" } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      DATA_DISABLED_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should NOT have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_form_with_data_asp_boolean_disabled_true
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~DATA_DISABLED_FORM
        <%= form_for @user, url: "/auto_permit", data: { asp_disabled: true } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      DATA_DISABLED_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should NOT have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_form_with_data_asp_boolean_disabled_false
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~DATA_DISABLED_FORM
        <%= form_for @user, url: "/auto_permit", data: { asp_disabled: false } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      DATA_DISABLED_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  def test_form_with_data_asp_disabled_string_disabled
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~DATA_DISABLED_FORM
        <%= form_for @user, url: "/auto_permit", data: { asp_disabled: "disabled" } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      DATA_DISABLED_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should NOT have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_form_with_data_asp_disabled_string_enabled
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~DATA_DISABLED_FORM
        <%= form_for @user, url: "/auto_permit", data: { asp_disabled: "enabled" } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      DATA_DISABLED_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  def test_form_with_data_asp_disable_long_name
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~DATA_DISABLED_FORM
        <%= form_for @user, url: "/auto_permit", "data-asp-disabled": "disabled" do |f| %>
          <%= f.text_field :name %>
        <% end %>
      DATA_DISABLED_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should NOT have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_form_without_data_asp_disabled_false_works
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~NORMAL_FORM
        <%= form_for @user, url: "/auto_permit", "data-asp-disabled": false do |f| %>
          <%= f.text_field :name %>
          <%= f.email_field :email %>
        <% end %>
      NORMAL_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  def test_form_without_data_asp_disabled_works
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~NORMAL_FORM
        <%= form_for @user, url: "/auto_permit" do |f| %>
          <%= f.text_field :name %>
          <%= f.email_field :email %>
        <% end %>
      NORMAL_FORM
    )]

    get :new
    assert_response :ok

    assert_select "form[id='new_user']"
    # Should have the ASP hidden tag
    assert_select "form[id='new_user'] input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  # ===== form_with tests (Rails 5+) =====

  def test_form_with_basic_functionality
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_BASIC
        <%= form_with model: @user, url: "/auto_permit" do |f| %>
          <%= f.text_field :name %>
          <%= f.email_field :email %>
        <% end %>
      FORM_WITH_BASIC
    )]

    get :new
    # Should have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  def test_form_with_data_asp_disabled_hash_true
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_DISABLED
        <%= form_with model: @user, url: "/auto_permit", data: { asp_disabled: true } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      FORM_WITH_DISABLED
    )]

    get :new
    # Should NOT have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_form_with_data_asp_disabled_hash_string_true
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_DISABLED
        <%= form_with model: @user, url: "/auto_permit", data: { asp_disabled: "true" } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      FORM_WITH_DISABLED
    )]

    get :new
    # Should NOT have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_form_with_data_asp_disabled_hash_disabled
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_DISABLED
        <%= form_with model: @user, url: "/auto_permit", data: { asp_disabled: "disabled" } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      FORM_WITH_DISABLED
    )]

    get :new
    # Should NOT have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_form_with_data_asp_disabled_hash_false
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_ENABLED
        <%= form_with model: @user, url: "/auto_permit", data: { asp_disabled: false } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      FORM_WITH_ENABLED
    )]

    get :new
    # Should have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  def test_form_with_data_asp_disabled_hash_enabled
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_ENABLED
        <%= form_with model: @user, url: "/auto_permit", data: { asp_disabled: "enabled" } do |f| %>
          <%= f.text_field :name %>
        <% end %>
      FORM_WITH_ENABLED
    )]

    get :new
    # Should have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  def test_form_with_data_asp_disable_string_key_disabled
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_STRING_DISABLED
        <%= form_with model: @user, url: "/auto_permit", "data-asp-disabled": "disabled" do |f| %>
          <%= f.text_field :name %>
        <% end %>
      FORM_WITH_STRING_DISABLED
    )]

    get :new
    # Should NOT have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']", false
  end

  def test_form_with_data_asp_disable_string_key_false
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_STRING_ENABLED
        <%= form_with model: @user, url: "/auto_permit", "data-asp-disabled": false do |f| %>
          <%= f.text_field :name %>
        <% end %>
      FORM_WITH_STRING_ENABLED
    )]

    get :new
    # Should have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']"
  end

  def test_form_with_url_syntax
    BasicController.view_paths = [ActionView::FixtureResolver.new(
      "basic/new.html.erb" => <<~FORM_WITH_URL
        <%= form_with url: "/auto_permit", "data-asp-disabled": "disabled" do |f| %>
          <%= f.text_field :name %>
        <% end %>
      FORM_WITH_URL
    )]

    get :new
    # Should NOT have the ASP hidden tag
    assert_select "form input[name='#{AutoStrongParameters.asp_message_key}']", false
  end
end
