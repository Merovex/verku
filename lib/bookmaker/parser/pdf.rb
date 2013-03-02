require 'kramdown'

module Bookmaker
  module Parser
    class PDF < Base
      def parse
        filename = root_dir.join("output/#{name}.tex")
        
        support_dir = "#{File.dirname(__FILE__)}/../support"
        output = File.read("#{support_dir}/template.tex")
        # out =  File.read("#{support_dir}/preamble.tex")
        # out << "\n\\begin{document}\n\n"
        # out << File.read("#{support_dir}/frontmatter.tex")
        # out << parse_layout(content)
        # out << "\\end{document}"
        output.gsub(%r{<!--CONTENTS-->}, parse_layout(content))
        
        File.open(filename, 'w').write(out)
        # File.open(filename, "w") do |file|
        #   file << "\\documentclass{book}\\begin{document}"
        #   file << File.read("#{File.dirname(__FILE__)}/../support/frontmatter.tex")
        #   file << parse_layout(content)
        #   file << "\\end{document}"
        # end
        # puts `xelatex #{filename}`
        true
      # rescue Exception
      #   false
      end
      def content
        raw = ""
        puts entries.inspect
        entries.each do |sections|
          sections.each do |s|
            raw << "\n#{File.read(s)}\n"
            # raw << File.read(s) + "\n"
          end
        end
        raw
      end
      def parse_layout(text)
        Kramdown::Document.new(text, :latex_headers => %w(chapter section subsection paragraph subparagraph subsubparagraph)).to_latex
      end
    end
  end
end