# -*- encoding: utf-8 -*-
require 'thor'
require 'bookmaker/version'
module Bookmaker
  class Cli < Thor
    FORMATS = %w[pdf draft proof html epub mobi txt]
    check_unknown_options!
    
    def self.exit_on_failure?
      true
    end
    def initialize(args = [], options = {}, config = {})
      if (config[:current_task] || config[:current_command]).name == "new" && args.empty?
        raise Error, "The e-Book path is required. For details run: bookmaker help new"
      end
      super
    end
    
    desc "create", "Start new work"
    map %w(create new) => :create
    def create(path)
      puts "Bookmaker -- A Million Monkeys Writing Your Masterpiece."
      generator = Generator.new
      generator.destination_root = path.squish.gsub(' ','-')
      generator.invoke_all
    end
    
    desc "compile [OPTIONS]", "Export e-book"
    map %w(compile export) => :export
    method_option :only, :type => :string, :desc => "Can be one of: #{FORMATS.join(", ")}"
    method_option :open, :type => :boolean, :desc => "Automatically open PDF (Preview.app for Mac OS X and xdg-open for Linux)"
    def export
      inside_ebook!
      if options[:only] && !FORMATS.include?(options[:only])
        raise Error, "The --only option need to be one of: #{FORMATS.join(", ")}"
      end
      Bookmaker::Exporter.run(root_dir, options)
    end
    
    desc "pdf", "Export PDF only"
    def pdf
      inside_ebook!
      Bookmaker::Exporter.run(root_dir, {:only => 'pdf'})
    end
    
    desc "version", "Prints the Bookmaker's version information"
    map %w(-v --version) => :version
    def version
      say "Bookmaker version #{Bookmaker::VERSION}"
    end
    
    desc "stats", "Display some stats about your e-book"
    def stats
      inside_ebook!
      stats = Bookmaker::Stats.new(root_dir)

      say [
        # "Chapters: #{stats.chapters}",
        "Goal:   #{sprintf("%7d", stats.target)}",
        "Words:  #{sprintf("%7d", stats.words)}",
        "        -------",
        "Left:   #{sprintf("%7d", stats.remaining)}",
        "\nProgress: #{sprintf("%5d", stats.today)}"
      ].join("\n")
    end

    desc "move old_id new_id", "Move scene to new sequence."
    def move(oid,nid)
      s = Structure.new(root_dir)
      s.move(oid,nid)
    end
    desc "trash [OPTIONS]", "Move scene to trash."
    def trash(scene_id)
      s = Structure.new(root_dir)
      s.trash(scene_id)
    end
    private
      def config
        YAML.load_file(config_path).with_indifferent_access
      end
      def config_path
        root_dir.join("_bookmaker.yml")
      end
      def root_dir
        @root ||= Pathname.new(Dir.pwd)
      end
      def inside_ebook!
        unless File.exist?(config_path)
          raise Error, "You have to run this command from inside an e-book directory."
        end
      end
  end
end