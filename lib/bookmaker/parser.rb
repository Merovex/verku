require 'open3'

module Bookmaker
  module Parser
    autoload :HTML  , "bookmaker/parser/html"
    autoload :PDF   , "bookmaker/parser/pdf"
#    autoload :Epub  , "bookmaker/parser/epub"
#    autoload :Mobi  , "bookmaker/parser/mobi"
#    autoload :Txt   , "bookmaker/parser/txt"

    class Base
      # The e-book directory.
      #
      attr_accessor :root_dir

      # Where the text files are stored.
      #
      attr_accessor :source

      def self.parse(root_dir)
        puts "Base.parse"
        new(root_dir).parse
        puts "exit"
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
        Bookmaker.config(root_dir)
      end
      def entries
        config['sections'].map{|s| Dir["**/#{s}"][0] }.compact
      end
      # Render a eRb template using +locals+ as data seed.
      #
      def render_template(file, locals = {})
        ERB.new(File.read(file)).result OpenStruct.new(locals).instance_eval{ binding }
      end
      def read_content(file)
        content = File.read(file)
        begin
          if content =~ /\A(---\s*\n.*?\n?)^(---\s*$\n?)/m
            content = "\n#{$'}\n"
            data = YAML.load($1)
          end
          return [content, data]
        rescue => e
          puts "Error reading file #{File.join(base, name)}: #{e.message}"
        rescue SyntaxError => e
          puts "YAML Exception reading #{File.join(base, name)}: #{e.message}"
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
