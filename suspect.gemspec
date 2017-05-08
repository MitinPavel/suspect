# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'suspect/version'

Gem::Specification.new do |spec|
  spec.name          = "suspect"
  spec.version       = Suspect::VERSION
  spec.authors       = ["Pavlo Mitin"]
  spec.email         = ["mitin.pavel@gmail.com"]

  spec.summary       = %q{Selects a subset of spec files to be run based on previous failures.}
  spec.description   = %q{Gathers spec failures revealing relationship between files in a project. Selects a subset of spec files to be run taking previous failures into account.}
  spec.homepage      = "https://github.com/MitinPavel/suspect"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
