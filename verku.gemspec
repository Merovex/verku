# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'verku/version'

Gem::Specification.new do |spec|
  spec.name = "verku"
  spec.version = Verku::VERSION

  spec.required_rubygems_version = Gem::Requirement.new(">= 0") if spec.respond_to? :required_rubygems_version=
  spec.require_paths = ["lib"]
  spec.authors = ["Merovex"]
  spec.description = "Verku provides authors a free, ruby-based production toolchain for self-published paper and electronic books using the LaTeX document preparation system."
  spec.email = ["dausha+verku@gmail.com"]
  spec.executables = ["verku"]
  spec.extra_rdoc_files = [
    "LICENSE.md",
    "README.md"
  ]
  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  # spec.files = [
  #   ".document",
  #   ".gitignore",
  #   ".rvmrc",
  #   "BUILD.md",
  #   "Gemfile",
  #   "Gemfile.lock",
  #   "LICENSE.md",
  #   "README.md",
  #   "Rakefile",
  #   "VERSION",
  #   "bin/verku",
  #   "lib/verku.rb",
  #   "lib/verku/adapters/markdown.rb",
  #   "lib/verku/build.rb",
  #   "lib/verku/cli.rb",
  #   "lib/verku/dependency.rb",
  #   "lib/verku/exporter.rb",
  #   "lib/verku/exporter/base.rb",
  #   "lib/verku/exporter/epub.rb",
  #   "lib/verku/exporter/html.rb",
  #   "lib/verku/exporter/mobi.rb",
  #   "lib/verku/exporter/pdf.rb",
  #   "lib/verku/exporter/txt.rb",
  #   "lib/verku/extensions/string.rb",
  #   "lib/verku/generator.rb",
  #   "lib/verku/source_list.rb",
  #   "lib/verku/statspec.rb",
  #   "lib/verku/stream.rb",
  #   "lib/verku/toc.rb",
  #   "lib/verku/toc/epub.rb",
  #   "lib/verku/toc/html.rb",
  #   "lib/verku/version.rb",
  #   "templates/config.erb",
  #   "templates/cover.jpg",
  #   "templates/dp-logo.png",
  #   "templates/epub/back.erb",
  #   "templates/epub/copyright.erb",
  #   "templates/epub/cover.erb",
  #   "templates/epub/cover.html",
  #   "templates/epub/page.erb",
  #   "templates/epub/user.css",
  #   "templates/extraspec.tex",
  #   "templates/html/copyright.erb",
  #   "templates/html/layout.css",
  #   "templates/html/layout.erb",
  #   "templates/html/syntax.css",
  #   "templates/html/thankspec.erb",
  #   "templates/html/user.css",
  #   "templates/latex.erb",
  #   "templates/merovex-logo.jpg",
  #   "templates/merovex-logo.png",
  #   "templates/pdf/layout.erb",
  #   "templates/rakefile.rb",
  #   "templates/readme.erb",
  #   "templates/text/01-Getting-Started.md",
  #   "templates/text/02-Creating-Chapterspec.md",
  #   "templates/text/03-Generating-Output.md",
  #   "templates/text/10-Test-Markdown.md",
  #   "test/helper.rb",
  #   "test/test_bookmaker.rb",
  #   "verku.gemspec"
  # ]
  spec.homepage = "https://github.com/Merovex/verku"
  spec.rubyforge_project = "verku"
  spec.rubygems_version = "2.2.2"
  spec.summary = "Verku is a Ruby & LaTeX based production toolchain for self-publisherspec."
  spec.test_files = ["test/helper.rb", "test/test_bookmaker.rb"]

  if spec.respond_to? :specification_version then
    spec.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      spec.add_development_dependency(%q<shoulda>, [">= 0"])
      spec.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      spec.add_development_dependency(%q<bundler>, ["~> 1.0"])
      # spec.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      spec.add_development_dependency(%q<simplecov>, [">= 0"])
      spec.add_runtime_dependency(%q<activesupport>, [">= 0"])
      spec.add_development_dependency(%q<aruba>, [">= 0"])
      spec.add_development_dependency(%q<cucumber>, [">= 0"])
      spec.add_runtime_dependency(%q<rubyzip>, [">= 0"])
      spec.add_runtime_dependency(%q<zip-zip>, [">= 0"])
      spec.add_runtime_dependency(%q<eeepub>, [">= 0"])
      spec.add_runtime_dependency(%q<kramdown>, [">= 0"])
      spec.add_runtime_dependency(%q<thor>, [">= 0"])
      spec.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      spec.add_runtime_dependency(%q<notifier>, [">= 0"])
      spec.add_runtime_dependency(%q<awesome_print>, [">= 0"])
      spec.add_runtime_dependency(%q<safe_yaml>, [">= 0"])
    else
      spec.add_dependency(%q<shoulda>, [">= 0"])
      spec.add_dependency(%q<rdoc>, ["~> 3.12"])
      spec.add_dependency(%q<bundler>, ["~> 1.0"])

      spec.add_dependency(%q<simplecov>, [">= 0"])
      spec.add_dependency(%q<activesupport>, [">= 0"])
      spec.add_dependency(%q<aruba>, [">= 0"])
      spec.add_dependency(%q<cucumber>, [">= 0"])
      spec.add_dependency(%q<rubyzip>, [">= 0"])
      spec.add_dependency(%q<zip-zip>, [">= 0"])
      spec.add_dependency(%q<eeepub>, [">= 0"])
      spec.add_dependency(%q<kramdown>, [">= 0"])
      spec.add_dependency(%q<thor>, [">= 0"])
      spec.add_dependency(%q<nokogiri>, [">= 0"])
      spec.add_dependency(%q<notifier>, [">= 0"])
      spec.add_dependency(%q<awesome_print>, [">= 0"])
      spec.add_dependency(%q<safe_yaml>, [">= 0"])
    end
  else
    spec.add_dependency(%q<shoulda>, [">= 0"])
    spec.add_dependency(%q<rdoc>, ["~> 3.12"])
    spec.add_dependency(%q<bundler>, ["~> 1.0"])
    spec.add_dependency(%q<simplecov>, [">= 0"])
    spec.add_dependency(%q<activesupport>, [">= 0"])
    spec.add_dependency(%q<aruba>, [">= 0"])
    spec.add_dependency(%q<cucumber>, [">= 0"])
    spec.add_dependency(%q<rubyzip>, [">= 0"])
    spec.add_dependency(%q<zip-zip>, [">= 0"])
    spec.add_dependency(%q<eeepub>, [">= 0"])
    spec.add_dependency(%q<kramdown>, [">= 0"])
    spec.add_dependency(%q<thor>, [">= 0"])
    spec.add_dependency(%q<nokogiri>, [">= 0"])
    spec.add_dependency(%q<notifier>, [">= 0"])
    spec.add_dependency(%q<awesome_print>, [">= 0"])
    spec.add_dependency(%q<safe_yaml>, [">= 0"])
  end
end

