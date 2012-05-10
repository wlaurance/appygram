# -*- encoding: utf-8 -*-
require File.expand_path('../lib/appygram/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name = %q{appygram}
  gem.version = Appygram::VERSION
  gem.authors = ["rfc2616"]
  gem.summary = %q{ appygram is a hosted service for sending messages from mobile/web apps }
  gem.description = %q{Appygram is the Ruby gem for communicating with http://appygram.com (hosted messaging service). It supports an exception reporting mechanism similar to http://exceptional.io, and this Ruby gem, forked from the Exceptional gem, emulates Exceptional functionality.}
  gem.email = %q{heittman.rob@gmail.com}
  gem.files =  Dir['lib/**/*'] + Dir['spec/**/*'] + Dir['spec/**/*'] + Dir['rails/**/*'] + Dir['tasks/**/*'] + Dir['*.rb'] + ["appygram.gemspec"]
  gem.homepage = %q{http://appygram.com/}
  gem.require_paths = ["lib"]
  gem.requirements << "json_pure, json-jruby or json gem required"
  gem.add_dependency 'rack'
end
