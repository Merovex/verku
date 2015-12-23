module Bookmaker
  class Exporter
    def self.run(root_dir, options)
      exporter = new(root_dir, options)
      exporter.export!
    end

    attr_accessor :root_dir
    attr_accessor :options

    def initialize(root_dir, options)
      @root_dir = root_dir
      @options = options
    end

    def ui
      @ui ||= Thor::Base.shell.new
    end

    def export!
      helper = root_dir.join("config/helper.rb")
      load(helper) if helper.exist?

      raise "Missing Templates directory (_templates)" unless File.exist?("_templates")
      raise "Missing Images directory (_images)" unless File.exist?("_images")
      raise "Missing Output directory (_output)" unless File.exist?("_output")

      puts "Missing Kindlegen" unless Dependency.kindlegen?
      puts "Missing XeLatex" unless Dependency.xelatex?
      # puts "Missing Html2Text" unless Dependency.html2text?

      export_pdf  = [nil, "pdf"].include?(options[:only])
      export_html = [nil, "html", "mobi", "epub"].include?(options[:only])
      export_epub = [nil, "mobi", "epub"].include?(options[:only])
      export_mobi = [nil, "mobi"].include?(options[:only])
      export_txt  = [nil, "txt"].include?(options[:only])

      exported = []
      exported << Parser::PDF.parse(root_dir) if export_pdf && Dependency.xelatex?# && Dependency.prince?
      exported << Parser::HTML.parse(root_dir) if export_html 
      epub_done = Parser::Epub.parse(root_dir) if export_epub
      exported << epub_done
      exported << Parser::Mobi.parse(root_dir) if export_mobi && epub_done && Dependency.kindlegen?
      # exported << Parser::Txt.parse(root_dir) if export_txt && Dependency.html2text?

      if exported.all?
        color = :green
        message = options[:auto] ? "exported!" : "** e-book has been exported"

        if options[:open] && export_pdf
          filepath = root_dir.join("output/#{File.basename(root_dir)}.pdf")

          if RUBY_PLATFORM =~ /darwin/
            IO.popen("open -a Preview.app '#{filepath}'").close
          elsif RUBY_PLATFORM =~ /linux/
            Process.detach(Process.spawn("xdg-open '#{filepath}'", :out => "/dev/null"))
          end
        end

        Notifier.notify(
          :image   => Bookmaker::ROOT.join("_templates/ebook.png"),
          :title   => "Bookmaker",
          :message => "Your \"#{config[:title]}\" e-book has been exported!"
        )
      else
        color = :red
        message = options[:auto] ? "could not be exported!" : "** e-book couldn't be exported"
      end

      ui.say message, color
    end

    def config
      Bookmaker.config(root_dir)
    end
  end
end