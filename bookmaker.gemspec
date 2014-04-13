# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "bookmaker/version"

Gem::Specification.new do |s|
  s.name        = "bookmaker"
  s.version     = Bookmaker::VERSION
  s.authors     = ["Merovex"]
  s.email       = ["dausha@gmail.com"]
  s.homepage    = "http://dausha.net/bookmaker"
  s.summary     = %q{Bookmaker is a Ruby & LaTeX based production toolchain for self-publishers.}
  s.description = %q{Bookmaker provides authors a free, ruby-based production toolchain for self-published paper and electronic books using the LaTeX document preparation system.}

  s.rubyforge_project = "bookmaker"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # https://github.com/technicalpickles/jeweler

  # specify any dependencies here; for example:
  s.add_dependency "activesupport"
  s.add_development_dependency "aruba"
  s.add_development_dependency "cucumber"
  s.add_dependency "rubyzip"
  s.add_dependency "zip-zip"
  s.add_dependency "eeepub"
  s.add_dependency "kramdown"
  s.add_dependency "thor"
  s.add_dependency "nokogiri"
  s.add_dependency "notifier"
end