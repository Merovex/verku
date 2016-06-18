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
      copy_file "pdf/layout.erb",         "_templates/pdf/layout.erb"
      copy_file "dp-logo.png",            "_images/logo.png"
      
      copy_file "html/layout.erb",        "_templates/html/layout.erb"
      copy_file "html/thanks.erb",        "_templates/html/thanks.erb"
      copy_file "html/copyright.erb",     "_templates/html/copyright.erb"
      copy_file "html/user.css",          "_templates/html/user.css"
      copy_file "html/layout.css",        "_templates/html/layout.css"
      copy_file "html/syntax.css",        "_templates/html/syntax.css"

      copy_file "epub/back.erb",          "_templates/epub/back.html"
      copy_file "epub/copyright.erb",     "_templates/epub/copyright.erb"
      copy_file "epub/cover.erb",         "_templates/epub/cover.erb"
      copy_file "epub/cover.html",        "_templates/epub/cover.html"
      copy_file "epub/page.erb",          "_templates/epub/page.erb"
      copy_file "epub/user.css",          "_templates/epub/user.css"

      copy_file "cover.jpg",              "_images/cover.jpg"
      copy_file "rakefile.rb",            "Rakefile"
      copy_file "extras.tex",             "_extras/dedications.tex"
    end
    def copy_sample_text
      directory "text", "text"
      # copy_file "sample.md",             "text/01_First-Chapter/01-Welcome.md"
      # copy_file "markdown-test.md",      "text/02_Second-Chapter/01-Markdown-Test-File.tex"
    end
    def create_directories
      empty_directory "_output"
      empty_directory "_images"
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