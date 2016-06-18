module Bookmaker
  module Parser
    class Mobi < Base
      def parse
        puts "-- Exporting MOBI"
        spawn_command ["kindlegen", epub_file.to_s,]
        true
      rescue Exception
        p $!, $@
        false
      end
      def epub_file
        root_dir.join("builds/#{name}.epub")
      end
    end
  end
end