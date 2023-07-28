require "rails"

[
  #'active_record',
  'active_model',
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

require_relative './test_app'

module Rails70
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

    config.middleware.delete Rack::Lock
    config.middleware.delete ActionDispatch::Flash
    config.secret_key_base = TestApp.secret_key_base
    routes.append(&TestApp.routes)
  end
end

require_relative './models'
require_relative './basic_controller'

Rails70::Application.initialize!
