require 'open3'
require "English"

module Verku
  class Exporter
    class Base

      attr_accessor :root_dir # The e-book directory.
      attr_accessor :source   # Where the text files are stored.

      EXTENSIONS = %w[markdown mkdown mkdn mkd md text]

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
      end

      # Return directory's basename.
      def name
        File.basename(root_dir)
      end
      def git_branch
        branch = if (File.exist?(root_dir.join(".git/HEAD")))
           "-" + File.read( root_dir.join(".git/HEAD") ).sub("ref: refs/heads/","").sub(/\n/,'')
        else
          ""
        end
        return branch
      end
      def base_name(ext='')
        oname = "#{name}#{git_branch}"
      end
      def output_name(ext='txt')
        root_dir.join("builds/#{base_name}.#{ext}")
      end

      # Return the configuration file.
      def config
        Verku.config(root_dir)
      end
      def build_data
        source_list.each do |file|
          data = read_content(file)[1]
        end
      end

      def source_list
        # @source_list ||= SourceList.new(root_dir)
        @source_list ||= Dir.glob("#{@root_dir.join('text')}/**/*.{#{EXTENSIONS.join(",")}}")
                         .sort
        ap @source_list
        return @source_list
      end
      def render_template(file, locals = {})
        ERB.new(File.read(file)).result OpenStruct.new(locals).instance_eval{ binding }
      end
      def ui
        @ui ||= Thor::Base.shell.new
      end
      def html_file
        output_name("html")
      end
      def epub_file
        output_name("epub")
      end
      def tex_file
        output_name("tex")
      end
      def read_content(file)
        content = File.read(file)
        data = {}
        begin
          # YAML_FRONT_MATTER_REGEXP = /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
          if content =~ /\A(---\s*\n.*?\n?)^((---|\.\.\.)\s*$\n?)/m
            content = $POSTMATCH
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
