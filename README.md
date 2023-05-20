# HotViewComponents

A ruby gem to tightly integrate View Components with Hotwire and Rails

## Installation

Add this line to your application's Gemfile:

```ruby
gem "hot_view_components"
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install hot_view_components
```

## Usage

This gem works in two ways:

- Importmap implementation
- Webpacker/JSBundler implementation

To use with importmaps, execute:

```
bin/rails hot_view_components:importmaps
```

To use with Webpacker/JSBundler, execute:

```
bin/rails hot_view_components:bundling
```

Then generate your first hot view component:

```
bin/rails generate hot_component ExampleComponent
```

> You can use a short-hand syntax, too:
>
> `bin/rails g hc ExampleComponent

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
