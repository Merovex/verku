require 'open3'
require "English"

module Verku
  class Exporter
    class Base
      
      attr_accessor :root_dir # The e-book directory.
      attr_accessor :source   # Where the text files are stored.
      
      def handle_error(error)
        ui.say "#{error.class}: #{error.message}", :red
        ui.say error.backtrace.join("\n"), :white
      end
      def self.export!(root_dir)
        new(root_dir).export!
      end

      def initialize(root_dir)
        @root_dir = Pathname.new(root_dir)
        @source = root_dir.join("text")
        @build = Verku::Build.new
      end

      # Return directory's basename.
      def name
        File.basename(root_dir)
      end

      # Return the configuration file.
      def config
        Verku.config(root_dir)
      end
      # def build_data
      #   Verku.build(root_dir)
      # end
      def source_list
        @source_list ||= SourceList.new(root_dir)
      end
      def render_template(file, locals = {})
        ERB.new(File.read(file)).result OpenStruct.new(locals).instance_eval{ binding }
      end
      def read_content(file)
        content = File.read(file)
        data = {}
        begin
          # YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
          if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
            # content = "\n#{$'}\n"
            content = $POSTMATCH
            # data = SafeYAML.load($1)
            data = YAML.load($1, :safe => true)
          end
          return [content, data]
        rescue SyntaxError => e
          puts "YAML Exception reading #{file}: #{e.message}"
        rescue Exception => e
          puts "Error reading file #{file}: #{e.message}"
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
