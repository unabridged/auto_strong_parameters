# frozen_string_literal: true

module AutoStrongParameters
  module AutoPermit
    extend ActiveSupport::Concern

    included do
      attr_accessor :_asp_parameters
    end

    def auto_permit!
      permit(auto_permitted_params)
    end

    def auto_permitted_params
      return [] unless asp_signature_valid?

      _asp_parameters
    end

    def asp_signature_valid?
      return false unless (sig = self[:_asp_message]).presence

      self._asp_parameters = AutoStrongParameters.verifier.verify(sig)
      true
    rescue => e
      false
    end
  end
end
