# Automatic Strong Parameters

Automatic Strong Parameters detects the fields included in a form and automatically permits them in the controller. You no longer need to manually enumerate the params you've submitted. You can fall back to standard Strong Parameters when you need custom behavior.

Rails 4.0 introduced Rails developers to the world of Strong Parameters. This gem is an extension to the model that Strong Parameters introduced, intended to reduce or eliminate the busy work that Strong Paramters introduced. As Giles Bowkett wrote, "tedious, repetitive work is for computers to do."


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
user_params = params.require(:user).auto_permit
@user = User.create(user_params)
```


## How to use

Add to your Gemfile, `bundle install` and go.

```ruby
gem 'strong_parameters-auto'
```

## Motivation

The previous model of including permitted attributes in the model was a limited design. Models could be updated by users of different roles and having a single list was too limited.

Strong Parameters moved permitted attribute assertions from the model to the controller. To this day, parameters are authorized in the controllers they are submitted to. This change was for the better because it meant that each controller could assert its own set of parameters.

Strong Parameters still has the problem that multiple forms can submit to a single endpoint. This requires controller-side configuration and knowing where each submission is coming from so that the correct parameters are authorized.

This design suggests that we can go one step further. Parameters are literally setup when you write your form code. Each `f.text_field` or `f.fields_for` says that you want that parameter in the form and accepted by the server. The form itself is the documentation as to what parameters can be submitted. 

The natural solution is for each form to handle authorizing its own set of parameters.

- It is safe due to signing of the auto-generated shape
- It is seamless to integrate due to automatically permitting on any action that detects a shape submission
- It allows graceful fallback to standard Strong Parameters


## Compatibility

- Ruby 2.7+ but should work fine with prior Rubies.
- Rails 4.0+

### Why support Rails 4?

There are thousands of Rails apps on old versions of Rails maintained by small teams that are daunted by big upgrades. This gem aims to help make working with Strong Parameters easier and more seamless. One big way we can do that is help relieve the maintenance burden for folks on old versions of Rails.



# TODO list

- Add a hidden field with a string of all the fields used in the form builder
- Add a hidden field with a signature, take value toJson, sign and encrypt it
- Look at how cookies are decrypted to decrypt server-side
- Patch ActionController::Parameters to have auto_permit and use the shape from the form
- For upgrades, we can suggest / allow a setting to try to catch the exception that SP raises and try to call auto_permit and don't raise.


# Future enhancements
- Add option to enforce that selects or really any values are submitted are only within the choicies that were actually rendered in the form. This makes the most sense for foreign keys.
