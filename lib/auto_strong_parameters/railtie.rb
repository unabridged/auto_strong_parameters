require 'rails/railtie'

module AutoStrongParameters
  class Railtie < ::Rails::Railtie
    config.to_prepare do
      ActionController::Base.send(:include, AutoStrongParameters::ControllerPermitter)
      ActionView::FormBuilder.send(:include, AutoStrongParameters::AutoFormParams)
    end
  end
end
