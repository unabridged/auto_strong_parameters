# frozen_string_literal: true

module AutoStrongParameters
  module AutoPermit
    def auto_permit!(key)
      shape = asp_auto_permitted_params

      require(key).permit(shape[key])
    end

    def asp_auto_permitted_params
      if sig = self[AutoStrongParameters.asp_message_key]
        AutoStrongParameters.verifier.verify(sig) rescue {}
      else
        {}
      end.with_indifferent_access
    end
  end
end
