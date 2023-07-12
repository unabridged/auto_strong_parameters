# frozen_string_literal: true

module AutoStrongParameters::AutoFormParams
  ASP_PREFIX = "<input type='hidden' name='_asp_params' value='"
  ASP_SUFFIX = "' />"

  private

  def form_tag_with_body(html_options, content)
    output = form_tag_html(html_options)
    output << content
    output << _asp_hidden_tag
    output.safe_concat("</form>")
  end

  def _asp_hidden_tag
    if _asp_fields.present?
      signature = AutoStrongParameters.verifier.generate(_asp_fields)
      (ASP_PREFIX + signature + ASP_SUFFIX).html_safe
    else
      ""
    end
  end
end
