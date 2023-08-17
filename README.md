# Auto Strong Parameters

Auto Strong Parameters detects the fields included in a form and automatically permits them in the controller. You no longer need to manually enumerate the params you've submitted. You can fall back to standard Strong Parameters when you need custom behavior.

Rails 4.0 introduced Rails developers to the world of Strong Parameters. This gem is an extension to the model that Strong Parameters introduced, intended to reduce or eliminate the busy work that Strong Paramters introduced. As Giles Bowkett wrote, "tedious, repetitive work is for computers to do."

- :white_check_mark: Seamless integration: replace `require(key).permit` calls with `auto_permit!(key)`
- :safety_vest: Safe from malicious tampering due to message signing
- :trophy: Graceful upgrade and fallback to standard Strong Parameters
- :bow: No more busy work enumerating permitted parameters twice

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


## How to use

Add to your Gemfile, `bundle install` and go.

```ruby
gem 'auto_strong_parameters'
```

## Motivation

The previous model of including permitted attributes in the model was a limited design. Models could be updated by users of different roles and having a single list was too limited.

Strong Parameters moved permitted attribute assertions from the model to the controller. To this day, parameters are authorized in the controllers they are submitted to. This change was for the better because it meant that each controller could assert its own set of parameters.

Strong Parameters still has the problem that multiple forms can submit to a single endpoint. This requires controller-side configuration and knowing where each submission is coming from so that the correct parameters are authorized. There is fundamentally always double entry of what parameters you want to save - once in the view, and once in the controller.

This design suggests that we can go one step further. Parameters are literally setup when you write your form code in your view. Each `f.text_field` or `f.fields_for` says that you want that parameter in the form and accepted by the server. The form itself is the documentation as to what parameters can be submitted. 

The natural solution is for each form to handle authorizing its own set of parameters.

## Compatibility

Official support is currently set for all supported Rails releases as well as stable releases maintained by Rails LTS. There is no separate branch for separate versions, it is a goal keep this gem compatible for the life of Strong Parameters (Rails 4.0 - present).

- Ruby 2.7+, but should work fine with Ruby 2.0+
- Rails 4.2, 5.2, 6.0+

### Unofficial compatibility

Our gemspec dictates Rails 4.0+ support but we do not test it. It may work but it is not officially supported. This is a "use at your own risk" allowance - you should seriously reconsider running Rails 4.0/4.1 and 5.0/5.1 because they do not receive security updates or attention from official sources or private companies at all.

### Why support Rails 4+?

There are thousands of Rails apps on old versions of Rails maintained by small teams that are unable to perform version upgrades. This gem aims to help make working with Strong Parameters easier and more seamless - one less headache when considering whether and when to upgrade. This is one way we can help relieve the upgrade and maintenance burden for folks on old versions of Rails.

Long-term support for non-officially-supported versions of Rails is offered by [Rails LTS](https://railslts.com) (no official affiliation, just a happy customer). Since Rails LTS is the only way that you can get these old versions of Rails to work with current Ruby versions, this gem is tested against them rather than the final releases from [rails/rails](https://github.com/rails/rails). In order to successfully run all our tests, you may need a license to get a copy of Rails LTS 4.2.

All that said, AutoStrongParameters should work fine with standard Rails 4.2 if you are running an older version of Ruby.
