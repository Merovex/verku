# encoding: utf-8

require 'rubygems'
require 'bundler'
require "bundler/gem_tasks"
task :default => :spec
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require './lib/verku/version.rb'
Gem::Specification.new do |spec|

  spec.name        = "verku"
  spec.version     = Verku::VERSION
  spec.authors     = ["Merovex"]
  spec.email       = ["dausha+verku@gmail.com"]
  spec.homepage    = "https://github.com/Merovex/verku"
  spec.summary     = %q{Verku is a Ruby & LaTeX based production toolchain for self-publishers.}
  spec.description = %q{Verku provides authors a free, ruby-based production toolchain for self-published paper and electronic books using the LaTeX document preparation system.}

  spec.rubyforge_project = "verku"

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # specify any dependencies here; for example:
  spec.add_dependency "activesupport"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "cucumber"
  spec.add_dependency "rubyzip"
  spec.add_dependency "zip-zip"
  spec.add_dependency "eeepub"
  spec.add_dependency "kramdown"
  spec.add_dependency "thor"
  spec.add_dependency "nokogiri"
  spec.add_dependency "notifier"
  spec.add_dependency "awesome_print"
  spec.add_dependency "safe_yaml"
end
# Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
end

desc "Code coverage detail"
task :simplecov do
  ENV['COVERAGE'] = "true"
  Rake::Task['test'].execute
end

# task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "verku #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
