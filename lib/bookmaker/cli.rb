# -*- encoding: utf-8 -*-
require 'thor'
module Bookmaker
  class Cli < Thor
    FORMATS = %w[pdf draft proof html epub mobi txt]
    check_unknown_options!
    
    def self.exit_on_failure?
      true
    end
    def initialize(args = [], options = {}, config = {})
      if config[:current_task].name == "new" && args.empty?
        raise Error, "The e-Book path is required. For details run: bookmaker help new"
      end
      super
    end
    
    desc "export [OPTIONS]", "Export e-book"
    method_option :only, :type => :string, :desc => "Can be one of: #{FORMATS.join(", ")}"
    method_option :open, :type => :boolean, :desc => "Automatically open PDF (Preview.app for Mac OS X and xdg-open for Linux)"

    def export
      if options[:only] && !FORMATS.include?(options[:only])
        raise Error, "The --only option need to be one of: #{FORMATS.join(", ")}"
      end
      # inside_ebook!
      puts "Here"

      Bookmaker::Exporter.run(root_dir, options)
    end
    
    desc "version", "Prints the Bookmaker's version information"
    map %w(-v --version) => :version
    def version
      # say "Bookmaker version #{Bookmaker::Version::VERSION}"
      say "Bookmaker version #{Bookmaker::VERSION}"
    end
    
    desc "stats", "Display some stats about your e-book"
    def stats
      # inside_ebook!
      # stats = Bookmaker::Stats.new(root_dir)

      say [
        "Chapters: #{stats.chapters}",
        "Words: #{stats.words}",
        "Images: #{stats.images}",
        "Links: #{stats.links}",
        "Footnotes: #{stats.footnotes}",
        "Code blocks: #{stats.code_blocks}"
      ].join("\n")
    end
    
    private
      def config
        YAML.load_file(config_path).with_indifferent_access
      end
      def config_path
        root_dir.join("_config.yml")
      end
      def root_dir
        @root ||= Pathname.new(Dir.pwd)
      end
  end
end