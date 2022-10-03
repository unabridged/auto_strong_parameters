require 'rails/railtie'

module StrongParameters::Auto
  class Railtie < ::Rails::Railtie
    config.to_prepare do
      ActionController::Base.send(:include, StrongParameters::Auto::ControllerPermitter)
      ActionView::FormBuilder.send(:include, StrongParameters::Auto::AutoFormParams)
    end
  end
end
