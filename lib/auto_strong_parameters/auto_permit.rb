# frozen_string_literal: true

module AutoStrongParameters
  module AutoPermit
    def auto_permit!
      permit(asp_auto_permitted_params)
    end

    def asp_auto_permitted_params
      @asp_auto_permitted_params ||=
        if sig = self[:_asp_message]
          AutoStrongParameters.verifier.verify(sig) rescue []
        else
          []
        end
    end
  end
end
