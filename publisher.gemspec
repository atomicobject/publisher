# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "publisher/version"

Gem::Specification.new do |s|
  s.rubyforge_project = "publisher"
  s.name        = "publisher"
  s.version     = Publisher::VERSION
  s.authors     = ["Atomic Object"]
  s.email       = ["dev@atomicobject.com"]
  s.homepage = 'http://atomicobject.github.com/publisher'

  s.summary = 'Event subscription and firing mechanism'
  s.description = 'publisher is a module for extending a class with event subscription and firing capabilities.  This is helpful for implementing objects that participate in the Observer design pattern.'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
