# require 'kramdown'
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
          spawn_command ["makeglossaries #{name}.glo"] if File.exist?("#{name}.glo")
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
        def content
          source_list.map do |file|
            Kramdown::Document.new(
              read_content(file)[0],
              :latex_headers => %w{chapter section subsection subsubsection paragraph subparagraph}
            ).to_latex
            # PandocRuby.markdown(read_content(file)[0], "top-level-division" => 'chapter').to_latex.fix_scenebreaks
          end.join("\n\n")
        end
    end
  end
end
