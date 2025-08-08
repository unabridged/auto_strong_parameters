# frozen_string_literal: true

module AutoStrongParameters
  module AutoPermit
    def auto_permit!(key)
      shape = asp_auto_permitted_params

      permitted_shape = shape[key]

      # Log the shape we're permitting so that developers who may need to use
      # StrongParameters directly can easily copy the shape into a regular
      # #permit call.
      AutoStrongParameters.logger.debug("AutoStrongParameters: Permitting params for key '#{key}' with shape: #{permitted_shape.inspect}")

      require(key).permit(permitted_shape)
    end

    def asp_auto_permitted_params
      if sig = self[AutoStrongParameters.asp_message_key]
        begin
          AutoStrongParameters.verifier.verify(sig)
        rescue => e
          AutoStrongParameters.logger.warn("AutoStrongParameters: Error verifying signature for params: #{e.message}")
          {}
        end
      else
        {}
      end.with_indifferent_access
    end
  end
end
