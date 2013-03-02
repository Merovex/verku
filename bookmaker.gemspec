# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bookmaker/version"

Gem::Specification.new do |s|
  s.name        = "bookmaker"
  s.version     = Bookmaker::VERSION
  s.authors     = ["Merovex"]
  s.email       = ["dausha@gmail.com"]
  s.homepage    = "http://dausha.net"
  s.summary     = %q{ODO: Write a gem summary}
  s.description = %q{ODO: Write a gem description}

  s.rubyforge_project = "bookmaker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_dependency "activesupport"
  s.add_development_dependency "aruba"
  s.add_development_dependency "cucumber"
  s.add_dependency "eeepub"
  s.add_dependency "kramdown"
  s.add_dependency "thor"  
  # s.add_dependency "erb"
  # s.add_dependency "logger"
  s.add_dependency "nokogiri"
  s.add_dependency "notifier"
  # s.add_dependency "open3"
  # s.add_dependency "optparse"
  # s.add_dependency "ostruct"
  # s.add_dependency "tempfile"
  # s.add_dependency "pathname"
end
