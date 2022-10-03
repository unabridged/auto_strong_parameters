# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require 'rails'

class FakeApplication < Rails::Application; end

Rails.application = FakeApplication
Rails.configuration.action_controller = ActiveSupport::OrderedOptions.new

require 'strong_parameters/auto'

module ActionController
  SharedTestRoutes = ActionDispatch::Routing::RouteSet.new
  SharedTestRoutes.draw do
    get ':controller(/:action)'
  end

  class Base
    include ActionController::Testing
    include SharedTestRoutes.url_helpers
  end

  class ActionController::TestCase
    setup do
      @routes = SharedTestRoutes
    end
  end
end

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }
