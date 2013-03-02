require 'kramdown'

module Bookmaker
  module Parser
    class PDF < Base
      def parse
        # puts "PDF Parse"
        filename = root_dir.join("output/#{name}.tex")
        File.open(filename, "w") do |file|
          file << "\\documentclass{book}\\begin{document}"
          file << File.read("../support/frontmatter.tex")
          file << parse_layout(content)
          file << "\\end{document}"
        end
        # puts `xelatex #{filename}`
        true
      rescue Exception
        false
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
        Kramdown::Document.new(text).to_latex
      end
    end
  end
end