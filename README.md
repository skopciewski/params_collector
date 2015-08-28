# ParamsCollector

[![Gem Version](https://badge.fury.io/rb/params_collector.svg)](http://badge.fury.io/rb/params_collector)

## Installation

Add this line to your application's Gemfile:

    gem 'params_collector'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install params_collector

## Usage

```ruby
require 'params_collector'

parser = ParamsCollector.expect do
  # <marshaler> <param_name> <default_value>
  boolean :option1
  boolean :option2, false
  number :num, 4
  string :desc
end

params = ... e.g. from request ...  -> { option1: true, desc: "foo" }

parser.parse(params)

```

then you can check if all expected parameters were parsed

```ruby
parser.valid?       # => true
```

and use that object in the same way as a hash

```ruby
parser[:option1]    # => true
parser[:option2]    # => false
parser[:num]        # => 4
parser[:desc]       # => "foo"

parser.to_hash      # => { option1: true, desc: "foo" }
parser.merge num: 2 # => { option1: true, num: 2, desc: "foo" }
```

If you call `to_hash` method, the output will contain only parameters that are 
valid, or where the default state was changed. 

If you define the `default_value` (e.g. `number :page, 1`), then the parser 
will be valid even if you do not specify e.g.`{ page: 123 }` to the 
`parse` method. 

### Marshalers

When you call `ParamsCollector.expect`, you should define, which parameters you 
expect to be parsed. You can do that by calling:

- `boolean :name, [default_value = false]` - converts: true|false, "yes|no", 
  "on|off", 1|0 to the `TrueClass` or `FalseClass`
- `number :name, [default_value = 0]` - converts digits and string with digits
  to the `Fixnum` or `Float`
- `string :name, [default_value = ""]`
- `hash :name, [default_value = {}]`
- `array :name, [default_value = []]`

### Creating the own marshaler

Marshaler class should respond to:
- `.value` and return stored value
- `.set(value)` to set new value

and register self in the ParamsCollector:

```ruby
ParamsCollector::Parser.register_marshaler("foo", self.name)
```

so: 

```ruby
class FooMarshaler
  ParamsCollector::Parser.register_marshaler("foo", name)

  attr_reader :value

  def initialize
    @value = nil
  end

  def set(value)
    @value = value
  end
end
```

## Versioning

See [semver.org][semver]

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

[semver]: http://semver.org/
