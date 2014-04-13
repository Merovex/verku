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
      template "config.erb", "_bookmaker.yml"
    end
    def copy_templates
      copy_file "latex.erb",  "templates/pdf/layout.erb"
      copy_file "dp-logo.png",  "images/dp-logo.png"

      copy_file "html.erb",   "templates/html/layout.erb"
      copy_file "user.css",   "templates/html/user.css"
      copy_file "layout.css", "templates/html/layout.css"
      copy_file "syntax.css", "templates/html/syntax.css"

      copy_file "back.erb",   "templates/epub/back.erb"
      copy_file "copyright.erb",   "templates/epub/copyright.erb"
      copy_file "cover.erb", "templates/epub/cover.erb"
      copy_file "epub.erb",   "templates/epub/page.erb"
      copy_file "epub.css",   "templates/epub/user.css"
      copy_file "cover.jpg",  "images/cover.jpg"
    end
    def copy_sample_text
      copy_file "sample.tex"   , "text/01_First-Chapter/01-Welcome.tex"
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