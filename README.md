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
#= require bootstrap-editable
```
or
```coffee
#= require bootstrap-editable-inline
```

You can choose between bootstrap/jqueryui/jquery and inline version

And this to your stylesheets

```scss
*= require bootstrap-editable
```

Choose between bootstrap/jqueryui/jquery

You can also insert this file
```coffee
#= require rails-editable
```
And you'll be able update everything directly.
```haml
%a{href: "#", class: "editable",'data-type' => 'text', 'data-model' => "post", 'data-name' => "name", 'data-url' => post_path(post), 'data-original-title' => "Your info here"}= post.name
```
or if nested
```haml
%a{href: "#", class: "editable",'data-type' => 'text', 'data-model' => "post", 'data-nested' => 'post_translations', 'data-name' => "name", 'data-nid' => "#{post.translation.id}", 'data-url' => post_path(post), 'data-original-title' => "Your info here"}= post.name
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

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
