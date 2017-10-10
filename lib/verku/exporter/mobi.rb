module Verku
  class Exporter
    class Mobi < Base
      def export!
        puts "-- Exporting MOBI"
        spawn_command ["kindlegen", epub_file.to_s,]
        true
      rescue Exception
        p $!, $@
        false
      end
    end
  end
end
