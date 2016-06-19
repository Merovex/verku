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
require "safe_yaml"

module Verku
  ROOT = Pathname.new(File.dirname(__FILE__) + "/..")

  require "verku/extensions/string"
  require "verku/cli"
  require "verku/dependency"
  
  require "verku/exporter"
  require "verku/exporter/base"
  require "verku/exporter/pdf"
  require "verku/exporter/html"
  require "verku/exporter/epub"
  require "verku/exporter/mobi"

  require "verku/generator"
  require "verku/adapters/markdown"
  # require "verku/parser"
  require "verku/source_list"
  require "verku/stats"
  require "verku/stream"
  # require "verku/structure"
  require "verku/toc"
  require 'verku/version'
    
  Encoding.default_internal = "utf-8"
  Encoding.default_external = "utf-8"

  def self.config(root_dir = nil)
    root_dir ||= Pathname.new(Dir.pwd)
    path = root_dir.join("_verku.yml")

    raise "Invalid Verku directory; couldn't found #{path} file." unless File.file?(path)
    content = File.read(path)
    erb = ERB.new(content).result
    YAML.load(erb, :safe => true)
    #YAML.load(erb)#.with_indifferent_access
  end
  def self.logger
     @logger ||= Logger.new(File.open("/tmp/verku.log", "a"))
  end
  def self.hi
    puts "hi"
  end
end
