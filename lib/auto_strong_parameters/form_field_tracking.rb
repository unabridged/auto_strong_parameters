# frozen_string_literal: true

module AutoStrongParameters::FormFieldTracking
  extend ActiveSupport::Concern

  included do
    attr_reader :_asp_fields
  end

  ASP_PREFIX = "<input type='hidden' name='_asp_message' value='"
  ASP_SUFFIX = "' />"

  NAME_REGEX = /name=\"(.*?)\"/

  TRACKED_FIELDS = %w(
    search_field telephone_field date_field time_field datetime_field
    month_field week_field url_field email_field number_field range_field
    file_field password_field text_area text_field
  )

  TRACKED_FIELDS.each do |name|
    module_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{name}(*args)
        super.tap do
          _asp_track_field(args[1])
        end
      end
    RUBY_EVAL
    # define_method name do |*|
    #   super.tap do |html|
    #     _asp_track_field(NAME_REGEX.match(res)[1])
    #   end
    # end
  end

  def radio_button(*)
    super
  end

  private

  def _asp_track_field(name)
    @_asp_fields ||= []
    @_asp_fields << name.to_s
  end
end
