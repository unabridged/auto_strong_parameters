# frozen_string_literal: true

module AutoStrongParameters::AutoFormParams
  extend ActiveSupport::Concern

  included do
    attr_reader :_asp_fields
  end

  ASP_NAME_REGEX = /\sname=\"(.+?)\"/
  ASP_DIGIT_REGEX = /\[\d+\]/

  TRACKED_FIELDS = %w(
    search_field telephone_field date_field time_field datetime_field
    month_field week_field url_field email_field number_field range_field
    file_field password_field text_area text_field
  )

  TRACKED_FIELDS.each do |name|
    module_eval <<-RUBY_EVAL, __FILE__, __LINE__ + 1
      def #{name}(*args)
        super.tap do |res|
          _asp_track_field(res)
        end
      end
    RUBY_EVAL
  end

  # TODO
  def radio_button(*)
    super
  end

  private

  def _asp_track_field(field)
    @_asp_fields ||= []
    @_asp_fields << field.match(ASP_NAME_REGEX)[1].gsub(ASP_DIGIT_REGEX, '[]')
  end

  # Generate a hidden input with the signed value of the params shape for this
  # form. Append to the form.
  def _asp_hidden_tag
    if _asp_fields.present?
      # puts "========= Adding tag =========="
      # puts _asp_fields.inspect
      name = AutoStrongParameters.asp_message_key
      to_sign = asp_fields_to_shape
      signature = AutoStrongParameters.verifier.generate(to_sign)

      "<input type='hidden' name='#{name}' value='#{signature}' />".html_safe
    else
      ""
    end
  end

  # This implementation is taken from Rails 7.0 but is largely the same as the
  # version found in Rails 4.2. Since Rails doesn't give us a nice hook to add
  # in our functionality, we do it by bringing in the full method and
  # augmenting it here.
  def form_tag_with_body(html_options, content)
    output = form_tag_html(html_options)
    output << content.to_s if content
    output << _asp_hidden_tag
    output.safe_concat("</form>")
  end

  # Concatenate all form element "name" values into a valid query string, parse
  # it with Rack, and then convert to a Strong Parameters "shape" to be signed
  # and sent to the server.
  def asp_fields_to_shape
    AutoStrongParameters.to_strong_params_shape(
      Rack::Utils.parse_nested_query(_asp_fields.join("=&") + "=")
    )
  end
end
