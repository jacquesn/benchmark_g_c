# BenchmarkGC

A lightweight gem for benchmarking garbage collect stats relevant to memory optimization.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'benchmark_g_c'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install benchmark_g_c

## Usage

```ruby
class Thing
  include BenchmarkGC

  # A method you want to benchmark
  def method_name
    do_some_stuff
  end

  # Add this method in order to benchmark (name doesn't matter)
  def check
    bcheck { method_name }
  end
end
```

In a console:

```ruby
Thing.new.check
```

#### Parameter options (all are optional):  
* **name**: *(string)* Print the name of the benchmarked code  
* **times**: *(integer)* Number of times to run the benchmarked code in succession  
* **logger**: *(boolean)* `ActiveRecord::Base.logger` should log

#### bcheck returns the value of the benchmarked code, making this possible:  
```ruby
class Thing
...
  def method_name
    bcheck { do_some_stuff }
  end
end
```
Now you can run any code that uses method_name, and method_name will get benchmarked each time it is run.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
