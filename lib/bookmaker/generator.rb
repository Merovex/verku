module Bookmaker
  class Generator < Thor::Group
    include Thor::Actions
    def self.source_root
      File.dirname(__FILE__) + "/../../templates"
    end
    def build_config_file      
      puts "Building Configuration File"
      @name = full_name
      @uid = Digest::MD5.hexdigest("#{Time.now}--#{rand}")
      @year = Date.today.year
      template "config.erb", "config/kitabu.yml"
    end
    def copy_sample_text
      puts "Copying Sample Text"
      copy_file ""
    end
    def create_directories
      puts "Creating Directories"
      empty_directory "output"
      empty_directory "images"
    end
    private
    # Retrieve user's name using finger.
    # Defaults to <tt>John Doe</tt>.
    #
    def full_name
      name = `finger $USER 2> /dev/null | grep Login | colrm 1 46`.chomp
      name.present? ? name.squish : "John Doe"
    end
  end
end