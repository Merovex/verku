require 'kramdown'

module Bookmaker
  module Parser
    class PDF < Base
      def parse
        locals = config.merge({
                  :contents => parse_layout(content)
                 })
        output = render_template(root_dir.join("templates/pdf/layout.erb"), locals)        
        File.open(root_dir.join("output/#{name}.tex"), 'w').write(output)
        true
      rescue Exception
        false
      end
      def parse_layout(text)
        text = text.join("\n\n")
        text.gsub!('* * *', "\n\n{::nomarkdown}\\pbreak{:/}\n\n")
        Kramdown::Document.new(text, :latex_headers => %w(chapter section subsection paragraph subparagraph subsubparagraph)).to_latex
      end
    end
  end
end