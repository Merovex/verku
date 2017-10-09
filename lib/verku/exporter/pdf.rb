require 'kramdown'
require "awesome_print"

module Verku
  class Exporter
    class PDF < Base
      def export!
        locals = config.merge({ :contents => content })
        locals['copyright'].gsub!("(C)", "\\copyright{}")
        output = render_template(root_dir.join("_templates/pdf/layout.erb"), locals)
        File.open(root_dir.join(tex_file), 'w').write(output)

        puts "-- Exporting PDF"
        puts "   - Pass 1"; spawn_command ["xelatex", tex_file.to_s,]
        puts "   - Pass 2"; spawn_command ["xelatex", tex_file.to_s,]

        if config['status'] == 'final'
          puts "   - Pass 3 - Indexing"
          spawn_command ["makeindex #{name}.idx"]
          # spawn_command ["makeglossaries #{name}.glo"]
          spawn_command ["xelatex", tex_file.to_s,]
          spawn_command ["rm *ilg *ind "]
        end

        spawn_command ["rm *.glo *.idx *.log *.out *.toc *aux *ist"]
        spawn_command ["mv #{base_name("pdf")}.pdf #{output_name("pdf")}"]
        true

      rescue Exception => error
        handle_error(error)
        false
      end

      private
        def render_file(file)
          data = read_content(file)
          h    = nil

          if config["headers"].is_a? Array
            h = config["headers"][0..5]
          end

          return "#{data[0]}".to_latex(h)
        end
        def content
          content = PandocRuby.markdown(source_list).to_latex
          content.gsub!('\begin{center}\rule{0.5\linewidth}{\linethickness}\end{center}','\pfbreak')
          return content
        end
        def tex_file
          output_name("tex")
        end
    end
  end
end
