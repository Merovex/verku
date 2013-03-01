# -*- encoding: utf-8 -*-
require 'thor'
module Bookmaker
  class Cli < Thor
    FORMATS = %w[pdf html epub mobi txt]
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
    
    desc "version", "Prints the Bookmaker's version information"
    map %w(-v --version) => :version

    desc "version", "Display version of bookmaker."
    def version
      # say "Bookmaker version #{Bookmaker::Version::STRING}"
      say "Bookmaker version #{Version::String}"
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
    # def config_path
    #   root_dir.join("_config.yml")
    # end
    # def root_dir
    #   @root ||= Pathname.new(Dir.pwd)
    # end
  end
end