require "rails"

[
  #'active_record',
  'action_controller',
  'action_view',
  #'action_mailer',
  #'active_job',
  'rails/test_unit',
  #'sprockets',
].each do |framework|
  begin
    require "#{framework}/railtie"
  rescue LoadError
  end
end

require 'action_view/testing/resolvers'
require 'rails/test_help'

require 'auto_strong_parameters'

module Rails60
  class Application < Rails::Application
    config.root = File.expand_path("../../..", __FILE__)
    config.cache_classes = true

    config.eager_load = false
    config.serve_static_files  = true
    config.static_cache_control = "public, max-age=3600"

    config.consider_all_requests_local       = true
    config.action_controller.perform_caching = false

    config.action_dispatch.show_exceptions = false

    config.action_controller.allow_forgery_protection = false

    config.active_support.deprecation = :stderr

    config.active_support.test_order = :sorted

    config.middleware.delete "Rack::Lock"
    config.middleware.delete "ActionDispatch::Flash"
    config.middleware.delete "ActionDispatch::BestStandardsSupport"
    config.secret_key_base = '49837489qkuweoiuoqwehisuakshdjksadhaisdy78o34y138974xyqp9rmye8yrpiokeuioqwzyoiuxftoyqiuxrhm3iou1hrzmjk'
    routes.append do
      post "auto_permit" => "basic#auto_permit"
      post "unpermitted" => "basic#unpermitted"
    end
  end
end

require_relative './basic_controller'

Rails60::Application.initialize!
