# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verku/version'

Gem::Specification.new do |spec|
  spec.name = "verku"
  spec.version = Verku::VERSION

  # spec.required_rubygems_version = Gem::Requirement.new("~> 0") if spec.respond_to? :required_rubygems_version=
  spec.require_paths             = ["lib"]
  spec.authors                   = ["Merovex"]
  spec.description               = "Verku provides authors a free, ruby-based production toolchain for self-published paper and electronic books using the LaTeX document preparation system."
  spec.email                     = ["dausha+verku@gmail.com"]
  spec.homepage                  = "https://github.com/Merovex/verku"
  spec.license                   = "MIT"
  spec.executables               = ["verku"]

  spec.extra_rdoc_files = [
    "LICENSE.md",
    "README.md"
  ]
  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }

  spec.rubyforge_project = "verku"
  spec.rubygems_version = "2.2.2"
  spec.summary = "Verku is a Ruby-/Markdown-/LaTeX-based production tool chain for self-publishers."
  spec.test_files = ["test/helper.rb", "test/test_bookmaker.rb"]

  spec.add_development_dependency "bundler",       "~> 1.12"
  spec.add_development_dependency "rake",          "~> 10.0"

  spec.add_runtime_dependency     "kramdown",      "~> 0"
  spec.add_runtime_dependency     "activesupport", "~> 5.0",    ">= 5.0.0"
  spec.add_runtime_dependency     "rubyzip",       "~> 1.0",    ">= 1.0.0"
  spec.add_runtime_dependency     "zip-zip",       "~> 0"
  spec.add_runtime_dependency     "eeepub",        "~> 0"
  spec.add_runtime_dependency     'pandoc-ruby'
  spec.add_runtime_dependency     'thor',          "~> 0.19",   ">= 0.19.1"
  spec.add_runtime_dependency     "nokogiri",      "~> 1.6",    ">= 1.6.0"
  spec.add_runtime_dependency     "notifier",      "~> 0"
  spec.add_runtime_dependency     "awesome_print", "~> 0"
  spec.add_runtime_dependency     "safe_yaml",     "~> 1.0"

end
