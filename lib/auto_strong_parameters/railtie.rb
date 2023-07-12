require 'auto_strong_parameters/auto_permit'
require 'auto_strong_parameters/auto_form_params'
require 'auto_strong_parameters/form_field_tracking'

module AutoStrongParameters
  require 'rails/railtie'

  class Railtie < ::Rails::Railtie
    initializer 'auto_strong_parameters.add_to_rails' do
      ActiveSupport.on_load :action_view do
        AutoStrongParameters::Railtie.apply_form_helpers_patch
      end

      ActiveSupport.on_load :action_controller do
        AutoStrongParameters::Railtie.apply_auto_permit_patch
      end
    end
  end

  class Railtie
    def self.apply_form_helpers_patch
      ActionView::Base.send(:include, AutoStrongParameters::AutoFormParams)
      ActionView::Base.send(:include, AutoStrongParameters::FormFieldTracking)
    end

    def self.apply_auto_permit_patch
      ActionController::Parameters.send(:include, AutoStrongParameters::AutoPermit)
    end
  end
end
