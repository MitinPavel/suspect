# Suspect

If you have **slow tests**, you need a troubleshooting strategy. It takes a lot of effort to get rid of this smell. In meantime it is good to have a palliative. `Suspect` provides such a band-aid. The gem collects test results along with VCS (Git) status and uses harvested data to select a subset of test files to be run.

## Tags

* Test Smells
* Slow Tests
* RSpec
* TDD
* BDD
* Anti-patterns

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'suspect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install suspect

Add to RSpec helper file:

```ruby
# spec/spec_helper.rb
require 'suspect/rspec_listener'

RSpec.configure do |config|

  ::Suspect::RSpecListener.setup_using config

```

Create a rake file:

```ruby
# lib/tasks/suspect.rake

namespace :suspect do
  desc 'run suspect test files in parallel'
  task :parallel_rspec do
    paths = ::Suspect::Prediction::Default.paths
    
    if paths.any?
      puts "#{paths.size} test file(s) are going to be run..."
      puts `bundle exec parallel_rspec #{paths.join(' ')} -n 7`
    else
      puts 'No test files found to be run'
    end
  end
end
```

## Usage

`Suspect` is conceptually divided into two parts:
* data gathering
* failure prediction

### Gathering

As soon as the gem is added to Gemfile and `Suspect::RSpecListener.setup_using config` is invoked in `spec/spec_helper.rb`, the gathering part is up and running. Each time you run specs, results are stored for further usage. Harvested data is stored under `suspect/` folder in *.suspect files. Adding *.suspect files under source control allows data sharing between project members.

### Prediction

`Suspect::Prediction::Default.paths` returns a list of spec files which are more likely to fall. The installation section above contains a simple rake task for the prediction phase. Fill free to modify the task to better meet your requirements.

## Assumptions

* A project uses:
  * Git
  * RSpec
  
## TODO  

* Basic error handling (especially for file operations)
* Enhanced Rake task examples in README:
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

