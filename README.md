# X::Editable::Rails

X-editable for Rails

## Installation

Add this line to your application's Gemfile:

    gem 'x-editable-rails'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install x-editable-rails

## Usage

Insert files to your application

```coffee
#= require editable/bootstrap-editable
```
You can choose between bootstrap-editable/jqueryui-editable/jquery-editable-poshytip

```scss
*= require editable/bootstrap-editable
```
You can choose between bootstrap-editable/jqueryui-editable/jquery-editable


You can also insert this file
```coffee
#= require editable/rails
```

This is simple helper using CanCan

First you need to create simple helper, which returns true or false (if is editable enabled or not)

```ruby
def xeditable?
  true # Or something like current_user.xeditable?
end
```

and this is how to use helper method

```ruby
%h1= editable @page, :name, e: @page.name
# editable object, what_you_want_update, e: exception - when is xeditable? false or can? :edit, object is false
```

or with nested attributes (globalize3 example) 
```ruby
%h1= editable @page, :name, nested: :translations, nid: @page.translation.id, e: @page.name
# nested: nested attributes, nid: id of nested attribute
```

Example of nested resource
```ruby
%h1= editable [picture.gallery, picture], :name, nested: :translations, nid: picture.translation.id, e: picture.name
```

You can also update everything directly.
```haml
%a{href: '#', class: 'editable', data: { type: 'text', model: 'post', name: 'name', url: post_path(post), 'original-title' => 'Your info here'}}= post.name
```
or if nested
```haml
%a{href: '#', class: 'editable', data: { type: 'text', model: 'post', nested: 'translations', name: 'name', nid: "#{post.translation.id}", url: post_path(post), 'original-title' => 'Your info here'}}= post.name
```

You need to specify:
1. data-model
2. data-name
3. data-url

When updating nested attributes also:
1. data-nested
2. data-nid

And don't forget to activate it
```coffee
$('.editable').editable()
```

Wysihtml5 editor

If you want edit text with wysihtml5 editor, you need to load his dependencies
For js
```coffee
#= require editable/bootstrap-editable
#= require editable/inputs-ext/bootstrap-wysihtml5/wysihtml5
#= require editable/inputs-ext/bootstrap-wysihtml5/bootstrap-wysihtml5
#= require editable/inputs-ext/wysihtml5
#= require editable/rails
```

And css
```sass
//= require editable/bootstrap-editable
//= require editable/inputs-ext/bootstrap-wysihtml5
//= require editable/inputs-ext/wysiwyg-color
```

```ruby
= editable @page, :content, nested: :translations, nid: @page.translation.id, type: :wysihtml5, e: @page.content.html_safe
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
