# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sinatra-linkedin/version"

Gem::Specification.new do |s|
  s.name        = "sinatra-linkedin"
  s.version     = Sinatra::Linkedin::VERSION
  s.authors     = ["Bob Nadler"]
  s.email       = ["bnadler@cyrusinnovation.com"]
  s.homepage    = ""
  s.summary     = %q{Provides helpers for accessing the LinkedIn API in Sinatra applications.}
  s.description = %q{Provides helpers for accessing the LinkedIn API in Sinatra applications.}

  s.rubyforge_project = "sinatra-linkedin"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake",      "~> 0.9.2"
  s.add_development_dependency "contest",   "~> 0.1.3"
  s.add_development_dependency "mocha",     "~> 0.10.0"
  s.add_development_dependency "rack-test", "~> 0.6.1"
  s.add_development_dependency "rdoc",      "~> 3.6.1"

  s.add_runtime_dependency "linkedin", "~> 0.3.6"
  s.add_runtime_dependency "sinatra",  "~> 1.3.1"
end
