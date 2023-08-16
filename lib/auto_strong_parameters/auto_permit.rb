# frozen_string_literal: true

module AutoStrongParameters
  module AutoPermit
    def auto_permit!(key)
      v = asp_auto_permitted_params
      require(key).permit(asp_auto_permitted_params[key.to_s])
    end

    def asp_auto_permitted_params
      @asp_auto_permitted_params ||=
        if sig = self[AutoStrongParameters.asp_message_key]
          AutoStrongParameters.verifier.verify(sig) rescue []
        else
          []
        end
    end
  end
end
