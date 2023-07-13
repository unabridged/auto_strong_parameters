# frozen_string_literal: true

module AutoStrongParameters::AutoFormParams
  extend ActiveSupport::Concern

  included do
    attr_reader :_asp_fields
  end

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

  # Generate a hidden input with the signed value of all params that were
  # appended to this form.
  def _asp_hidden_tag
    if _asp_fields.present?
      puts "========= Adding tag =========="
      puts _asp_fields.inspect
      name = AutoStrongParameters.asp_message_key
      signature = AutoStrongParameters.verifier.generate(_asp_fields)
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
end
