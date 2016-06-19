require 'kramdown'
require "awesome_print"

module Verku
  class Exporter
    class PDF < Base
      def content
        content = String.new
        source_list.each_chapter do |files|
          content << "\n#{render_chapter(files)}\n"
        end
        return content
      end
      
      def export!
        puts "-- Exporting PDF"
        locals = config.merge({ :contents => content })
        locals['copyright'].gsub!("(C)", "\\copyright{}")
        output = render_template(root_dir.join("_templates/pdf/layout.erb"), locals)
        File.open(root_dir.join(tex_file), 'w').write(output)
        
        puts "    - Pass 1"; spawn_command ["xelatex", tex_file.to_s,]
        puts "    - Pass 2"; spawn_command ["xelatex", tex_file.to_s,]

        if config['status'] == 'final'
          puts "    - Pass 3 - Indexing"
          spawn_command ["makeindex #{name}.idx"]
          # spawn_command ["makeglossaries #{name}.glo"]
          spawn_command ["xelatex", tex_file.to_s,]
          spawn_command ["rm *ilg *ind "]
        end
        
        spawn_command ["rm *.glo *.idx *.log *.out *.toc *aux *ist"]
        spawn_command ["mv #{name}.pdf builds/#{name}.pdf"]
        true
      rescue Exception
        p $!, $@
        false
      end

      def tex_file
        root_dir.join("builds/#{name}.tex")
      end

      private
        def render_file(file)
          data = read_content(file)
          content = "#{data[0]}".to_latex
          return content
        end
        def render_chapter(files)
          chapter = ""
          String.new.tap do
            files.each do |file|
              chapter << render_file(file) << "\n\n"
            end
          end
          return chapter
        end
    end
  end
end
