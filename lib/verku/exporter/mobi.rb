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
      def epub_file
        # root_dir.join("builds/#{name}.epub")
        output_name("epub")
      end
    end
  end
end
