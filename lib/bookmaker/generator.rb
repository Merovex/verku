module Bookmaker
  class Generator < Thor::Group
    include Thor::Actions
    def self.source_root
      File.dirname(__FILE__) + "/../../templates"
    end
    def build_config_file      
      @title = File.basename(destination_root).gsub('-', ' ')
      @name = full_name
      @uid = Digest::MD5.hexdigest("#{Time.now}--#{rand}")
      @year = Date.today.year
      template "config.erb", "_config.yml"
    end
    def copy_templates
      copy_file "latex.erb",  "templates/pdf/layout.erb"
      copy_file "html.erb",   "templates/html/layout.erb"
    end
    def copy_sample_text
      copy_file "sample.md"   , "text/01-Welcome.md"
    end
    def create_directories
      empty_directory "output"
      empty_directory "images"
    end
    private
      # Retrieve user's name using finger.
      # Defaults to <tt>John Doe</tt>.
      #
      def full_name
        name = `finger $USER 2> /dev/null | grep Login | colrm 1 46`.chomp
        name.empty? ? "John Doe" : name.squish
      end
  end
end