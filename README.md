# Auto Strong Parameters

Auto Strong Parameters detects the fields included in a form and automatically permits them in the controller. You no longer need to manually enumerate the params you've submitted. You can fall back to standard Strong Parameters when you need custom behavior.

Rails 4.0 introduced Rails developers to the world of Strong Parameters. This gem is an extension to the model that Strong Parameters introduced, intended to reduce or eliminate the busy work that Strong Parameters introduced. As Giles Bowkett wrote, "tedious, repetitive work is for computers to do."

- :white_check_mark: Seamless integration: replace `require(key).permit` calls with `auto_permit!(key)`
- :safety_vest: Safe from malicious tampering due to message signing
- :trophy: Graceful upgrade and fallback to standard Strong Parameters
- :bow: No more busy work enumerating permitted parameters twice

## How it works (TL;DR)

```ruby
# Replace this...
user_params = params.require(:user).permit(:first_name, :email)

# ...with this
user_params = params.auto_permit!(:user)
```

## How it works

Before:
```ruby

# View
<%= form_with @user do |f| %>
  First name: <%= f.text_field :first_name %>
  Email: <%= f.email_field :email %>
<% end %>


# Controller
user_params = params.require(:user).permit(:first_name, :email)
# => { first_name: "Dave", email: "dave@example.com }
@user = User.create(user_params)
```

After:

```ruby
# View - unchanged
<%= form_with @user do |f| %>
  First name: <%= f.text_field :first_name %>
  Email: <%= f.email_field :email %>
<% end %>


# Controller - no enumeration required, your form dictates what is allowed
user_params = params.auto_permit!(:user)
# => { first_name: "Dave", email: "dave@example.com }
@user = User.create(user_params)
```


## Getting started

Add to your Gemfile, `bundle install` and go.

```ruby
gem 'auto_strong_parameters'
```

## Public API

Automatically permit parameters for a given key.

```ruby
# In a controller:

# Get automatically permitted params for the :user key
params.auto_permit!(:user)

# Return a hash of params that were auto-permitted for this request.
asp_auto_permitted_params
```

Disable/enable ASP globally

```ruby
AutoStrongParamters.enabled = false
AutoStrongParamters.enabled? # false
AutoStrongParamters.disabled? # true
```

Disable ASP for a single form (works with `form_for` and `form_with`):

```ruby
# Disabled, use 'disabled', true, or 'true'
<%= form_with @user, data: { asp_disabled: true } do |f| %>
<%= form_with @user, "data-asp-disabled": 'disabled' do |f| %>

# Enabled, anything else
<%= form_for @user, "data-asp-disabled": 'enabled' do |f| %>
<%= form_for @user, "data-asp-disabled": 'false' do |f| %>
```

Global options:

```ruby
# Name of the HTML hidden input that stores the signed parameter shape
AutoStrongParamters.asp_message_key = :whatever_you_want
# Custom logger
AutoStrongParamters.logger = MyCustomLogger
# Custom message verifier, must match public API with ActiveSupport::MessageVerifier
AutoStrongParamters.verifier = MyCustomVerifier
# Use a different secret
AutoStrongParamters.secret = 'super duper secret'
```


## How does it work?

ASP patches all standard Rails form builder input helpers to keep a list of every field added to your form (including text fields, radio buttons, textareas, hidden fields, [and more](https://github.com/unabridged/auto_strong_parameters/blob/main/lib/auto_strong_parameters/auto_form_params.rb#L13). Before placing the closing `</form>` tag into your HTML, ASP places [a hidden field](https://github.com/unabridged/auto_strong_parameters/blob/main/lib/auto_strong_parameters/auto_form_params.rb#L106) with the signed "shape" of your parameters, suitable for passing into the normal Strong Parameters API `params.require(:user).permit(your_forms_param_shape)`. ASP uses `ActiveSupport::MessageVerifier` to [sign the shape](https://github.com/unabridged/auto_strong_parameters/blob/main/lib/auto_strong_parameters/auto_form_params.rb#L94) using your application's `secret_key_base` to prevent tampering with the shape.

## Motivation

The Rails 2.x design of including permitted attributes in the model was a limited design. Models could be updated by users of different roles and having a single list was too restrictive.

Strong Parameters moved permitted attribute assertions from the model to the controller. To this day, parameters are authorized in the controllers they are submitted to. This change was for the better because it meant that each controller could assert its own set of parameters.

Strong Parameters still has the problem that multiple forms can submit to a single controller action. This issues means developers must implement controller-side configuration and know where each submission is coming from so that the correct parameters are authorized for all allowed situations. Additionally, there is fundamentally always double entry of what parameters you want to save - once by adding an input to your form and once again in the controller.

This design suggests that we can go one step further. Parameters are literally setup when you write your form code in your view. Each `f.text_field` or `f.number_field` says that you want that parameter in the form and accepted by the server. The form itself is the documentation as to what parameters can be submitted. 

The natural solution is for the framework to handle authorizing the parameters that the developer already told it to put in the form.

## Compatibility

Official support is currently set for all supported Rails releases as well as stable releases maintained by Rails LTS. There is no separate branch for separate versions, it is a goal keep this gem compatible for the life of Strong Parameters (Rails 4.0 - present).

- Ruby 2.7+, but should work fine with Ruby 2.0+
- Rails 4.2, 5.2, 6.0+

### Form Builders

Auto Strong Parameters currently only supports the built-in Rails form builder class. If you use a different form builder and would like to see it supported, open a ticket, or better yet, write it and contribute back!

### Unofficial compatibility

Our gemspec dictates Rails 4.0+ support but we do not test versions 4.0, 4.1, 5.0, or 5.1. It may work on those versions but it is not officially supported. This is a "use at your own risk" allowance - you should seriously reconsider running Rails 4.0/4.1 and 5.0/5.1 because they do not receive security updates or attention from official sources or private companies at all.

### Why support Rails 4+?

There are thousands of Rails apps on old versions of Rails maintained by small teams that are unable to perform version upgrades. This gem aims to help make working with Strong Parameters easier and more seamless - one less headache when considering whether and when to upgrade. This is one way we can help relieve the upgrade and maintenance burden for folks on old versions of Rails.

Long-term support for non-officially-supported versions of Rails is offered by [Rails LTS](https://railslts.com) (no official affiliation, just a happy customer). Since Rails LTS is the only way that you can get these old versions of Rails to work with current Ruby versions, this gem is tested against them rather than the final releases from [rails/rails](https://github.com/rails/rails). In order to successfully run all our tests, you will need a license to get a copy of Rails LTS 4.2 and 5.2.

All that said, AutoStrongParameters should work fine with standard Rails 4.2 even if you are running an EOL version of Ruby.


## Running the tests

To run the tests for day to day development, ensure you have Ruby 3.1+ installed and active, clone the repo, `bundle install` and then run `rake`. Bundler will install a different version of Rails depending on the version of Ruby you've got: Rails 7.2 (Ruby 3.1) or Rails 8 (Ruby 3.2+).

To run the tests against all supported versions:

```bash
# Run the tests for Ruby 3.1-tested Rails versions (4.2, 5.2)
rbenv shell 3.1.7
bundle exec rake appr_31

# Run the tests for Ruby 3.3-tested Rails versions (6.0+)
rbenv shell 3.3.7
bundle exec rake appr_33
```

## Contributing

Contributions are welcome! If you use it and it doesn't work for you, please open an issue! If it DOES work for you, also let me know - all feedback is welcome and helps inform future development. Check the TODO.md file if you're looking for inspiration.
