require 'rails/railtie'
require 'auto_strong_parameters/auto_permit'

module AutoStrongParameters
  class Railtie < ::Rails::Railtie
    config.to_prepare do
      ActionController::Parameters.send(:include, AutoStrongParameters::AutoPermit)
      #ActionController::Base.send(:include, AutoStrongParameters::ControllerPermitter)
      #ActionView::FormBuilder.send(:include, AutoStrongParameters::AutoFormParams)
    end
  end
end
