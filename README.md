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


# Controller - require/permit already done
@user = User.create(params[:user])
```


## How to use

Add to your Gemfile, `bundle install` and go.

```ruby
gem 'strong_parameters-auto'
```

## API

Use the data attribute `data-sp_auto_extra` to instruct your form to include fields that should be allowed but not be there when the form renders. The value should be a Hash or Array in the shape of a typical Strong Paramters hash. It will be merged with the auto-generated shape.

```ruby
<%= form_with model, data: { sp_auto_extra: [:time_zone] } %>
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
