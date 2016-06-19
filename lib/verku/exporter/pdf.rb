require 'kramdown'

module Verku
  class Exporter
    class PDF < Base
      def content
        raw = []
        entries.keys.each do |chapter|
          title = (chapter.empty?) ? "Untitled" : chapter.split('_')[1]
          title = 'Untitled' if title.nil?
          raw << "\\Chapter{#{title.gsub('-',' ')}}\n\n"
          entries[chapter].each do |section|
            s = read_content(section)[0].to_latex.gsub(/\$(\\index\{[^\$]*?\})\$/) {"#{$1}"}
            raw << "#{s}\n\n* * *"
          end
        end
        raw
      end
      
      def export!
        puts "-- Exporting PDF"
        locals = config.merge({ :contents => parse_layout(content) })
        locals['copyright'].gsub!("(C)", "\\copyright{}")
        output = render_template(root_dir.join("_templates/pdf/layout.erb"), locals)
        File.open(root_dir.join(tex_file), 'w').write(output)
        
        puts "    - Pass 1"; spawn_command ["xelatex", tex_file.to_s,]
        puts "    - Pass 2"; spawn_command ["xelatex", tex_file.to_s,]

        if config['is_final'].to_i == 0
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
      def parse_layout(text)
        text = text.join("\n\n")
        text.gsub!('* * *', "\n\n\\pbreak{}\n\n")
      end
      def tex_file
        root_dir.join("builds/#{name}.tex")
      end
    end
  end
end
