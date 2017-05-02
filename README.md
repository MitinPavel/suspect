# Suspect

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/suspect`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'suspect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install suspect

## Usage

```ruby
# Gemfile
gem 'suspect', :path => '/home/pm/projects/suspect'
```

```ruby
# spec/spec_helper.rb
require 'suspect/rspec_listener'

RSpec.configure do |config|

  ::Suspect::RSpecListener.setup_using config
  
  # ...
end  
```

```ruby
# lib/tasks/suspect.rake

namespace :suspect do
  desc 'List suspect test files'
  task :list do |t, args|
    #...
  end
end

```

## Assumptions

* Your project uses:
  * Git
  * RSpec
  
## TODO  

* Basic error handling (especially for file operations)
* Rake task examples in README:
  * run rspec taking collected data into account
  * run parallel_tests taking collected data into account
* More sophisticated strategies for finding test files to be run

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/suspect. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

