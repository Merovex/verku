# require "bookmaker/version"
require "active_support/all"
require "awesome_print"
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

module Bookmaker
  
  ROOT = Pathname.new(File.dirname(__FILE__) + "/..")
  
  autoload :Cli,        "bookmaker/cli"
  autoload :Exporter,   "bookmaker/exporter"
  autoload :Generator,  "bookmaker/generator"
  autoload :Markdown,   "bookmaker/adapters/markdown"
  autoload :Parser,     "bookmaker/parser"
  autoload :Stats,      "bookmaker/stats"
  autoload :TOC,        "bookmaker/toc"
  autoload :Version,    "bookmaker/version"
    
  Encoding.default_internal = "utf-8"
  Encoding.default_external = "utf-8"

  def self.config(root_dir = nil)
    root_dir ||= Pathname.new(Dir.pwd)
    path = root_dir.join("_config.yml")

    raise "Invalid Bookmaker directory; couldn't found #{path} file." unless File.file?(path)
    content = File.read(path)
    erb = ERB.new(content).result

    YAML.load(erb)#.with_indifferent_access
  end
  def self.logger
     @logger ||= Logger.new(File.open("/tmp/bookmaker.log", "a"))
  end
  def self.hi
    puts "hi"
  end
end
