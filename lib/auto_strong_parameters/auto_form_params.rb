# frozen_string_literal: true

module AutoStrongParameters::AutoFormParams
  extend ActiveSupport::Concern

  included do
    attr_reader :_asp_fields
  end

  ASP_PREFIX = "<input type='hidden' name='_asp_params' value='"
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
  end

  def radio_button(*)
    super
  end

  private

  def _asp_track_field(name)
    @_asp_fields ||= []
    @_asp_fields << name.to_s
  end

  def _asp_hidden_tag
    if _asp_fields.present?
      signature = AutoStrongParameters.verifier.generate(_asp_fields)
      (ASP_PREFIX + signature + ASP_SUFFIX).html_safe
    else
      ""
    end
  end

  def form_tag_with_body(html_options, content)
    output = form_tag_html(html_options)
    output << content
    output << _asp_hidden_tag
    output.safe_concat("</form>")
  end
end
