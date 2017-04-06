$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'suspect'

Dir[File.dirname(__FILE__) + '/support/**/*.rb'].each {|f| require f }
