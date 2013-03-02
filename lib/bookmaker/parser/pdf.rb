require 'kramdown'

module Bookmaker
  module Parser
    class PDF < Base
      def parse
        filename = root_dir.join("output/#{name}.tex")
        
        support_dir = "#{File.dirname(__FILE__)}/../support"
        output = File.read("#{support_dir}/template.tex")
        output.gsub!(%r{<!--CONTENTS-->}, parse_layout(content))
        output.gsub!(%r{<!--AUTHOR-->}, config['author']['name'])
        output.gsub!(%r{<!--TITLE-->}, config['title'])
        output.gsub!(%r{<!--IBSN-->}, config['title'])
        output.gsub!(%r{<!--COVERDESIGN-->}, config['design']['cover'] || '')
        output.gsub!(%r{<!--BOOKDESIGN-->}, config['design']['book'] || '')
        output.gsub!(%r{<!--ISBN-->}, config["isbn"].to_s)
        
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