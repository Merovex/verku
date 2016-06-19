# require "verku/version"
require "active_support/all"
require 'fileutils'
#require "awesome_print"
require "eeepub"
require "erb"
require "logger"
require "nokogiri"
require "notifier"
require "open3"
require "optparse"
require "ostruct"
require "tempfile"
require "pathname"
require "thor"
require "thor/group"
require "yaml"
require "cgi"

module Verku
  
  require "verku/extensions/string"
  ROOT = Pathname.new(File.dirname(__FILE__) + "/..")
  
  autoload :Cli,        "verku/cli"
  autoload :Dependency, "verku/dependency"
  autoload :Exporter,   "verku/exporter"
  autoload :Generator,  "verku/generator"
  autoload :Markdown,   "verku/adapters/markdown"
  # autoload :Parser,     "verku/parser"
  autoload :SourceList,     "verku/source_list"
  autoload :Stats,      "verku/stats"
  autoload :Stream,     "verku/stream"
  autoload :Structure,  "verku/structure"
  autoload :TOC,        "verku/toc"
  autoload :Version,         'verku/version'
  # autoload :Version,    "verku/version"
    
  Encoding.default_internal = "utf-8"
  Encoding.default_external = "utf-8"

  def self.config(root_dir = nil)
    root_dir ||= Pathname.new(Dir.pwd)
    path = root_dir.join("_verku.yml")

    raise "Invalid Verku directory; couldn't found #{path} file." unless File.file?(path)
    content = File.read(path)
    erb = ERB.new(content).result

    YAML.load(erb)#.with_indifferent_access
  end
  def self.logger
     @logger ||= Logger.new(File.open("/tmp/verku.log", "a"))
  end
  def self.hi
    puts "hi"
  end
end
