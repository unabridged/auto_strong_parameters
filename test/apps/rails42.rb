require 'rails/all'
require 'action_view/testing/resolvers'
require 'rails/test_help'

require 'auto_strong_parameters'

module Rails42
  class Application < Rails::Application
    config.root = File.expand_path("../../..", __FILE__)
    config.cache_classes = true

    config.eager_load = false
    config.serve_static_assets  = true
    config.static_cache_control = "public, max-age=3600"

    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false

    config.action_dispatch.show_exceptions = false

    config.action_controller.allow_forgery_protection = false

    config.active_support.deprecation = :stderr

    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::Flash"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"
    config.secret_key_base = '49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk'
    routes.append do
      get "/" => "welcome#index"
    end
  end
end

class WelcomeController < ActionController::Base
  include Rails.application.routes.url_helpers
  layout 'application'
  self.view_paths = [ActionView::FixtureResolver.new(
    "layouts/application.html.erb" => '<%= yield %>',
    "welcome/index.html.erb"=> 'Hello from index.html.erb',
  )]

  def index
  end
end

Rails42::Application.initialize!
