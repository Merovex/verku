module Bookmaker
  module Parser
    class PDF < Base
      def parse
        puts "PDF Parse"
        File.open(root_dir.join("output/#{name}.tex"), "w") do |file|
          file << parse_layout(content)
        end
        true
      rescue Exception
        false
      end
      def content
      end
    end
  end
end