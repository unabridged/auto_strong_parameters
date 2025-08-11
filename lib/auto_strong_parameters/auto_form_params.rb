# frozen_string_literal: true

module AutoStrongParameters::AutoFormParams
  extend ActiveSupport::Concern

  included do
    attr_reader :_asp_fields, :_asp_original_options
  end

  ASP_NAME_REGEX = /\sname=\"(.+?)\"/
  ASP_DIGIT_REGEX = /\[\d+\]/

  TRACKED_FIELDS = %w(
    check_box
    collection_check_boxes
    collection_radio_buttons
    collection_select
    color_field
    date_field
    datetime_field
    datetime_local_field
    email_field
    file_field
    grouped_collection_select
    hidden_field
    month_field
    number_field
    password_field
    phone_field
    radio_button
    range_field
    rich_text_area
    search_field
    select
    telephone_field
    text_area
    text_field
    time_field
    time_zone_select
    trix_editor
    url_field
    week_field
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

  # Override form_for to capture original options. This is the only way to
  # capture data attributes that are provided via string like
  # "data-asp-disabled". This method signature matches Rails 4 through 7.
  def form_for(record, options = {}, &block)
    @_asp_original_options = options.dup
    super
  end

  private

  def _asp_track_field(field)
    @_asp_fields ||= []

    if match_data = field.match(ASP_NAME_REGEX)
      @_asp_fields << match_data[1].gsub(ASP_DIGIT_REGEX, '[]')
    end
  end

  # Generate a hidden input with the signed value of the params shape for this
  # form. Append to the form.
  def _asp_hidden_tag
    if _asp_fields.present?
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
    if auto_strong_parameters_enabled?(html_options)
      output << _asp_hidden_tag
    end
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

  def auto_strong_parameters_enabled?(opts)
    return false if AutoStrongParameters.disabled?

    # Check both processed options and original options
    # Use trailing predicates instead of ||= to handle false values.
    inline_val = opts.dig("data", :asp_disabled)
    inline_val = opts["data-asp-disabled"] if inline_val.nil?
    inline_val = opts[:data_asp_disabled] if inline_val.nil?
    inline_val = opts[:'data-asp-disabled'] if inline_val.nil?

    # If not found in processed options, check original options from form_for
    if inline_val.nil? && defined?(@_asp_original_options) && @_asp_original_options
      inline_val = @_asp_original_options["data-asp-disabled"]
      inline_val = @_asp_original_options[:'data-asp-disabled'] if inline_val.nil?
    end

    # If inline_val is blank, ASP is enabled by default
    # If inline_val is explicitly set to disable ASP, honor that
    # Otherwise ASP is enabled (including for 'enabled' and 'false' values)
    !inline_val.to_s.in?(['disabled', 'true'])
  end
end
