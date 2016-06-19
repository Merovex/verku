require 'open3'

module Verku
  class Exporter
    # autoload :HTML  , "verku/exporter/html"
    # autoload :PDF   , "verku/exporter/pdf"
    # autoload :Epub  , "verku/exporter/epub"
    # autoload :Mobi  , "verku/exporter/mobi"
#    autoload :Txt   , "verku/exporter/txt"

    class Base
      # The e-book directory.
      #
      attr_accessor :root_dir

      # Where the text files are stored.
      #
      attr_accessor :source

      def self.export!(root_dir)
        new(root_dir).export!
      end

      def initialize(root_dir)
        @root_dir = Pathname.new(root_dir)
        @source = root_dir.join("text")
      end

      # Return directory's basename.
      #
      def name
        File.basename(root_dir)
      end

      # Return the configuration file.
      #
      def config
        Verku.config(root_dir)
      end
      def entries
        # return @entries unless @entries.nil?
        # files = Dir["text/**/*.md"]
        # @entries = {}
        # files.each do |f|
        #   k = File.dirname(f)
        #   k.gsub!('text/','')
        #   @entries[k] = [] if @entries[k].nil?
        #   @entries[k] << f

        # end
        # return @entries
        @entries ||= SourceList.new(@source)
      end
      def render_template(file, locals = {})
        ERB.new(File.read(file)).result OpenStruct.new(locals).instance_eval{ binding }
      end
      def read_content(file)
        content = File.read(file)
        data = {}
        begin
# YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
          if    content   =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
            # content = "\n#{$'}\n"
            content = $POSTMATCH
            data = SafeYAML.load($1)
            # data = YAML.load($1)
          end
          return [content, data]
        rescue SyntaxError => e
          puts "YAML Exception reading #{path}: #{e.message}"
        rescue Exception => e
          puts "Error reading file #{path}: #{e.message}"
        end
      end
      def spawn_command(cmd)
        begin
          stdout_and_stderr, status = Open3.capture2e(*cmd)
        rescue Errno::ENOENT => e
          puts e.message
        else
          puts stdout_and_stderr unless status.success?
          status.success?
        end
      end
    end
  end
end
