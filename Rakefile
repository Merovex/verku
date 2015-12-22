# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  gem.name        = "bookmaker"
  # gem.version     = Bookmaker::VERSION
  gem.authors     = ["Merovex"]
  gem.email       = ["dausha+bookmaker@gmail.com"]
  gem.homepage    = "https://github.com/Merovex/bookmaker"
  gem.summary     = %q{Bookmaker is a Ruby & LaTeX based production toolchain for self-publishers.}
  gem.description = %q{Bookmaker provides authors a free, ruby-based production toolchain for self-published paper and electronic books using the LaTeX document preparation system.}

  gem.rubyforge_project = "bookmaker"

  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.require_paths = ["lib"]

  # https://github.com/technicalpickles/jeweler

  # specify any dependencies here; for example:
  gem.add_dependency "activesupport"
  gem.add_development_dependency "aruba"
  gem.add_development_dependency "cucumber"
  gem.add_dependency "rubyzip"
  gem.add_dependency "zip-zip"
  gem.add_dependency "eeepub"
  gem.add_dependency "kramdown"
  gem.add_dependency "thor"
  gem.add_dependency "nokogiri"
  gem.add_dependency "notifier"
end
Jeweler::RubygemsDotOrgTasks.new

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

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "bookmaker #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
