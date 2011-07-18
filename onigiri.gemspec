# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "onigiri/version"

Gem::Specification.new do |s|
  s.name        = "onigiri"
  s.version     = Onigiri::VERSION
  s.authors     = ["Dmitrii Soltis"]
  s.email       = ["slotos@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Attempt to replicate (at least some) functions of tidy utility}
  s.description = %q{This gem is supposed to replace a tidy-ext in one of our projects. Tidy-ext has nasty memory leaks, tends to crash and is incompatible with Ruby 1.9. So here I am trying to use a japanese saw to make some rice balls.}
  s.date        = "2011-07-18"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "nokogiri"
  s.add_development_dependency "rspec", ">= 2.0.0"
  s.add_development_dependency "autotest"
end
