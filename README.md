# BenchmarkGC

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/benchmark_g_c`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

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

class Thing
  include BenchmarkGC

  def method_name
    do_some_stuff
  end
end

Thing.new.bcheck(logger: false) { method_name }

Parameter options (all are optional):
  name: (string) Print the name of the benchmarked code
  times: (integer) Number of times to run the benchmarked code in succession
  logger: (boolean) ActiveRecord::Base.logger should log

bcheck returns the value of the benchmarked code, making this possible:
class Thing
...
  def method_name
    bcheck { do_some_stuff }
  end
end

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/benchmark_g_c.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
