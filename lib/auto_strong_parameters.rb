# frozen_string_literal: true

require 'rails'
require 'auto_strong_parameters/railtie'

module AutoStrongParameters
  def self.asp_message_key
    @asp_message_key ||= :"_asp_params"
  end

  def self.asp_message_key=(val)
    @asp_message_key = val
  end

  def self.secret=(secret)
    @secret = secret
  end

  def self.secret
    @secret ||= Rails.application.config.secret_key_base
  end

  def self.to_strong_params_shape(obj)
    items = Set.new
    hsh = {}

    case obj
    when Hash
      obj.each do |key, val|
        case val
        when Hash
          hsh[key] ||= {}
          hsh[key] = to_strong_params_shape(val)
        when Array
          hsh[key] ||= []
          hsh[key] << to_strong_params_shape(val)
        else
          items << key.to_s
        end
      end
      if hsh.empty?
        items.flatten.to_a
      elsif items.empty?
        hsh
      else
        hsh.transform_values!(&:flatten)
        [*items.flatten, hsh].flatten
      end

    when Array
      obj.each do |item|
        case item
        when Hash
          items << to_strong_params_shape(item)
        when Array
          items << to_strong_params_shape(item)
        else
          # nothing
        end
      end

      if hsh.empty?
        items.flatten.to_a
      else
        hsh.transform_values!(&:flatten)
        [*items.flatten, hsh]
      end

    else
      nil
    end
  end

  # Rails' message_verifier exists with a stable API in all versions of Rails
  # since 4.2.
  def self.verifier
    @verifier ||= ActiveSupport::MessageVerifier.new(secret, serializer: JSON)
  end

  # Provide your own custom verifier for AutoStrongParameters. Must respond to
  # #generate which takes an object and returns a string and #verify which
  # takes a string and returns an object.
  def self.verifier=(custom_verifier)
    @verifier = custom_verifier
  end
end
