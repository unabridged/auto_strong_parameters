# frozen_string_literal: true

require 'rails'
require 'auto_strong_parameters/railtie'

module AutoStrongParameters
  # Rails' message_verifier exists with a stable API in all versions of Rails
  # since 4.2.
  def self.verifier
    @verifier ||=
      ActiveSupport::MessageVerifier.new("auto_strong_parameters", serializer: JSON)
  end

  # Provide your own custom verifier for AutoStrongParameters. Must respond to
  # #generate which takes an object and returns a string and #verify which
  # takes a string and returns an object.
  def self.verifier=(custom_verifier)
    @verifier = custom_verifier
  end

  def self.asp_message_key
    @asp_message_key ||= :"_asp_params"
  end

  def self.asp_message_key=(val)
    @asp_message_key = val
  end

  def self.to_strong_params_shape(obj)
    res = []
    case obj
    when Hash
      obj.each do |k, v|
        case v
        when Hash
          res << { k.to_s => to_strong_params_shape(v) }
        when Array
          res << k.to_s
        else
          res << k.to_s
        end
      end
      res
    when Array
      res
    else
      nil
    end
  end
end
