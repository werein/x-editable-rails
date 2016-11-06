# X::Editable::Rails

[![Build Status](https://travis-ci.org/werein/x-editable-rails.svg)](https://travis-ci.org/werein/x-editable-rails)  [![Code Climate](https://codeclimate.com/github/werein/x-editable-rails/badges/gpa.svg)](https://codeclimate.com/github/werein/x-editable-rails) [![Test coverage](https://codeclimate.com/github/werein/x-editable-rails/badges/coverage.svg)](https://codeclimate.com/github/werein/x-editable-rails) [![Version](https://badge.fury.io/rb/x-editable-rails.svg)](https://badge.fury.io/rb/x-editable-rails) [![Dependencies](https://gemnasium.com/werein/x-editable-rails.svg)](https://gemnasium.com/werein/x-editable-rails)

X-editable for Rails

## Live demo

Checkout live demo [here](https://x-editable-rails.herokuapp.com/?denied=true) 

## Installation

Add this line to your application's Gemfile:

    gem 'x-editable-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install x-editable-rails

## Usage

### Assets

Choose between the following javascripts:

* bootstrap-editable
* bootstrap2-editable
* jqueryui-editable
* jquery-editable-poshytip

You'll also need to include editable/rails in your scripts for this to work.

```coffee
#= require editable/bootstrap-editable
#= require editable/rails
```

Choose the corresponding stylesheets:

* bootstrap-editable
* bootstrap2-editable
* jqueryui-editable
* jquery-editable

```scss
// as CSS
*= require editable/bootstrap-editable

// or SCSS
@import "editable/bootstrap-editable";
```

Enable editing with jQuery:

```coffee
$('.editable').editable()
```

For custom inputs like the Wysihtml5 editor, add these dependencies:

```coffee
#= require editable/bootstrap-editable
#= require editable/inputs-ext/wysihtml5
#= require editable/inputs-ext/bootstrap-wysihtml5
#= require editable/inputs-ext/wysihtml5-editable
#= require editable/rails
```

And related stylesheets:

```css
//= require editable/bootstrap-editable
//= require editable/inputs-ext/bootstrap-wysihtml5
//= require editable/inputs-ext/wysiwyg-color
```

### Making Things Editable

`x-editable-rails` provides a helper method in your view to make your model values editable.
By default, you need to specify the model and property that should be editable.
A `span` element is rendered with `data-*` attributes used by `x-editable`.

```ruby
# the editable object and the attribute to edit
%h1= editable @model, :name
```

You can customize the tag name and title attribute:

* **tag** - `span` by default.
* **title** - The model and attribute name are used to create a capitalized title

The `editable` helper method automatically adds these `data-*` attributes used by [x-editable](http://vitalets.github.io/x-editable/docs.html).

* **url** - Uses the `polymorphic_path(model)` helper method.
* **source** - Only populated if the value is a boolean to convert `true` or `false` to "Yes" and "No".
* **value** - Uses `model.name`. If `model.name` were a boolean value or if a `source` is specified, the `source` text would be displayed rather than the raw value. (Presumably the value is an ID and the source would have the text associated with that value.)
* **placeholder** - Uses the `title` value by default

```ruby
# editable object, what_you_want_update, e: exception - when is xeditable? false or can? :edit, object is false
%h1= editable @model, :name, url: model_path, value: @model.name.upcase
```

Here are some special features to enhance what's baked into [x-editable](http://vitalets.github.io/x-editable/docs.html):

* **type** - The type of input is automatically detected. By default, if the value is a boolean, the `type` is "select" with a built-in `source` that outputs "Yes" and "No" (unless another `source` is specified).
* **source** - In addition to hashes or arrays of hashes, you can also use an array of strings for a simpler structure if the name and value are the same:

```ruby
source = [ "Active", "Disabled" ]
editable @model, :enabled, source: source
```

* **value** - This option will override the `model.name` value
* **classes** - This is a custom option for `x-editable-rails` that will change the editable element's CSS class based on the selected value. Use the `source` hash structure to map a CSS class name to a value. (This [functionality](vendor/assets/javascripts/editable/rails/data_classes.js.coffee) is toggled when the value changes and the "save" event is triggered.)

```ruby
source  = [ "Active", "Disabled" ]
classes = { "Active" => "label-success", "Disabled" => "label-default" }
editable @model, :enabled, source: source, classes: classes, class: "label"
```

* **nested** - Name of a nested attributes (such as [globalize](https://github.com/globalize/globalize)'s `translations`)
* **nid** - ID of the nested attribute

```ruby
%h1= editable @model, :name, nested: :translations, nid: @model.translation.id

# example of nested resource
%h1= editable [picture.gallery, picture], :name, nested: :translations, nid: picture.translation.id
```

### Authorization

Add a helper method to your controllers to indicate if `x-editable` should be enabled.

```ruby
def xeditable? object = nil
  true # Or something like current_user.xeditable?
end
```

You can use [CanCan](https://github.com/ryanb/cancan) and checks the `:edit` permission for the model being edited.

```ruby
def xeditable? object = nil
  can?(:edit, object) ? true : false
end
```

* **e** - Specify a custom (error) message to display if the value isn't editable

### "Don't Repeat Yourself" Templates

To make your views cleaner, you can specify all your options for each class and attribute in a YAML configuration file.
Attributes where the `title` or `placeholder` are not different except maybe capitalized can be left out because they are automatically capitalized when rendered (see above).

This example uses the `MailingList` class and its attributes.
The attribute value can be a string, which is used as the `title` and `placeholder`.
If you want to specify other options, create a hash of options.

Install configuration file like this: `rails g x_editable_rails:install`, this step is not necessary

```yaml
class_options:
  MailingList:
    # Specify placeholder text for each attribute or a Hash of options
    name: Mailing list name
    enabled:
      type: select
      source:
        - Active
        - Disabled
    reply_email:
      type: email
      title: Reply-to email
  User:
    email:
      type: email
    password:
      type: password
    mailing_lists:
      type: select
      # specify a URL to get source via AJAX (see x-editable docs)
      source: <%= ::Rails.application.routes.url_helpers.mailing_lists_source_path %>
```

Now you can specify your editable fields without options because they will be inherited from your YAML config.

```ruby
model = MailingList.new

editable model, :name    # type: "text",   title: "Mailing list name"
editable model, :enabled # type: "select", title: "Enabled", source: [ "Active", "Disabled" ]
```

### Examples

Gem also contains demo application with integrated x-editable

```
cd test/dummy
rake db:migrate
rake db:seed
rails g x_editable_rails:install # optional, it generate config example
rails s
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
