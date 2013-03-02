require 'kramdown'
module Bookmaker
  module Parser
    class EPUB < Base
      def parse
        support_dir = "#{File.dirname(__FILE__)}/../support"
        filename = root_dir.join("output/#{name}.html")

        output = File.read("#{support_dir}/template.html")
        output.gsub!(%r{<!--CONTENTS-->}, parse_layout(content))

        File.open(filename, 'w').write(output)
      end
      def parse_layout(text)
        text.gsub!('* * *', "\n\n{::nomarkdown}<mbp:pagebreak/>{:/}\n\n")
        Kramdown::Document.new(text).to_html
      end
    end