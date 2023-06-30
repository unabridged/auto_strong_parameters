require 'rails'
require 'auto_strong_parameters/railtie'

module AutoStrongParameters
  def self.verifier
    Rails.application.message_verifier("auto_strong_parameters")
  end
end
