require 'kramdown'

module Bookmaker
  module Parser
    class PDF < Base
      def content
        puts "In content"
        raw = []
        entries.keys.each do |chapter|
          raw << "{::nomarkdown}\\Chapter{#{chapter.split(/_/)[1].gsub('-',' ')}}{:/}"
          entries[chapter].each do |section|
            raw << read_content(section)[0] + "\n\n* * *"
          end
        end
        raw
      end
      def parse
        locals = config.merge({
                  :contents => parse_layout(content)
                 })
        locals['copyright'].gsub!("(C)", "\\copyright{}")
        output = render_template(root_dir.join("templates/pdf/layout.erb"), locals)
        File.open(root_dir.join(tex_file), 'w').write(output)
        spawn_command ["xelatex", tex_file.to_s,]
        spawn_command ["xelatex", tex_file.to_s,]
        true
      rescue Exception
        false
      end
      def parse_layout(text)
        text = text.join("\n\n")
        text.gsub!('* * *', "\n\n{::nomarkdown}\\pbreak{:/}\n\n")
        Kramdown::Document.new(text).to_latex
      end
      def tex_file
        root_dir.join("output/#{name}.tex")
      end
    end
  end
end