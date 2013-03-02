require 'kramdown'
require 'awesome_print'

module Bookmaker
  module Parser
    class PDF < Base
      def parse
        filename = root_dir.join("output/#{name}.tex")
        
        # support_dir = "#{File.dirname(__FILE__)}/../support"
        locals = config.merge({
                  "contents"   => parse_layout(content)
                  # :toc       => toc.to_html,
                  # :changelog => render_changelog
                 })
                 ap locals
                 ap root_dir.join("templates/pdf/layout.erb")
        output = render_template(root_dir.join("templates/pdf/layout.erb"), locals)
        
        File.open(filename, 'w').write(output)
        true
      # rescue Exception
      #   false
      end
      def parse_layout(text)
        text.gsub!('* * *', "\n\n{::nomarkdown}\\pbreak{:/}\n\n")
        Kramdown::Document.new(text, :latex_headers => %w(chapter section subsection paragraph subparagraph subsubparagraph)).to_latex
      end
    end
  end
end