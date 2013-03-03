require 'kramdown'
module Bookmaker
  module Parser
    class HTML < Base
      def content
        raw = []
        entries.keys.each do |chapter|
          text = "<h2>#{chapter.split(/_/)[1].gsub('-',' ').titleize}</h2>"
          sections = []
          entries[chapter].each do |section|
            sections << "<p>#{read_content(section)[0].split(/\n{2,}/).map do |s|
              s.gsub!(/%.*/, '')
              s.squish
              # s.gsub!("\n", ' ')
              # s.chomp
            end.join("</p>\n\n<p>")}</p>"
          end
          text << sections.join("\n\n<hr />\n\n")
          raw << "<div class='chapter'>\n#{text}\n</div>\n"
        end
        raw
      end
      def parse
        puts "-- Exporting HTML"
        html = parse_layout(content)
        toc = TOC::HTML.generate(html)
        locals = config.merge({
                  :contents  => toc.content,
                  :toc       => toc.to_html,
                 })
        output = render_template(root_dir.join("templates/html/layout.erb"), locals)        
        File.open(root_dir.join("output/#{name}.html"), 'w').write(output)
        true
      rescue Exception
        p $!, $@
        false
      end
      def parse_layout(chapters)
        output = ''
        chapters.each do |text|
          # text.gsub!("{%", "{")
          # text.gsub!(/%.*/,'')
          text.gsub!(/``(.*?'?)''/) { "&ldquo;#{$1}&rdquo;"}
          text.gsub!(/``/, "&ldquo;")
          text.gsub!(/\b'\b/) { "&#39;" }
          text.gsub!(/`(.*?)'/) { "&lsquo;#{$1}&rsquo;"}
          # \{([^\}]+?)\} Within the curly braces.
          text.gsub!(/\\Dash\{\}/, "&mdash;")
          text.gsub!(/\\begin\{quote\}(.*?)\\end\{quote\}/m) { "<blockquote>#{$1.strip}</blockquote>"}
          text.gsub!(/<\/blockquote>\s+?<blockquote>/m, "\n")
          text.gsub!(/\\begin\{([^\}]+?)\}(.*?)\\end\{[^\}]+?\}/m) { "<div class='#{$1.strip}'>#{$2.strip}</div>"}
          text.gsub!(/\\section\{([^\}]+?)\}/m) { "<h3>#{$1.strip}</h3>"}
          text.gsub!(/\\emph\{([^\}]+?)\}/m) { "<em>#{$1.strip}</em>"}
          text.gsub!(/\\thought\{([^\}]+?)\}/m) { "<em>#{$1.strip}</em>"}
          text.gsub!(/\\(.*?)\{([^\}]+?)\}/) { "<span class='#{$1}'>#{$2.strip}</span>"}
          text.gsub!(/\\(.*?)\{([^\}]+?)\}/) { "<span class='#{$1}'>#{$2.strip}</span>"}
          text.gsub!(/<\/span>\{[^\}]+?}/, "</span>")
          text.gsub!(/<p><h([1-6])>(.*?)<\/h[1-6]><\/p>/) { "<h#{$1}>#{$2.strip}</h#{$1}>"}
          text.gsub!(/(\S+)~(\S+)/) { "#{$1}&nbsp;#{$2}"}
          # text.gsub!(/> +/, ">")
          output << text
        end
        output.gsub!(/\n\n+/, "\n\n")
        return output
      end
    end
     #  # List of directories that should be skipped.
     #   #
     #   IGNORE_DIR = %w[. .. .svn]
     # 
     #   # Files that should be skipped.
     #   #
     #   IGNORE_FILES = /^(CHANGELOG|TOC)\..*?$/
     # 
     #   # List of recognized extensions.
     #   #
     #   EXTENSIONS = %w[md mkdn markdown]
     # 
     #   class << self
     #     # The footnote index control. We have to manipulate footnotes
     #     # because each chapter starts from 1, so we have duplicated references.
     #     #
     #     attr_accessor :footnote_index
     #   end
     # 
     #   # Parse all files and save the parsed content
     #   # to <tt>output/book_name.html</tt>.
     #   #
     #   def parse
     #     reset_footnote_index!
     # 
     #     # File.open(root_dir.join("output/#{name}.html"), "w") do |file|
     #     #   file << parse_layout(content)
     #     # end
     #     true
     #   rescue Exception
     #     false
     #   end
     # 
     #   def reset_footnote_index!
     #     self.class.footnote_index = 1
     #   end
     # 
     #   private
     #   def chapter_files(entry)
     #     # Chapters can be files outside a directory.
     #     if File.file?(entry)
     #       [entry]
     #     else
     #       Dir.glob("#{entry}/**/*.{#{EXTENSIONS.join(",")}}").sort
     #     end
     #   end
     # 
     #   # Check if path is a valid entry.
     #   # Files/directories that start with a dot or underscore will be skipped.
     #   #
     #   def valid_entry?(entry)
     #     entry !~ /^(\.|_)/ && (valid_directory?(entry) || valid_file?(entry))
     #   end
     # 
     #   # Check if path is a valid directory.
     #   #
     #   def valid_directory?(entry)
     #     File.directory?(source.join(entry)) && !IGNORE_DIR.include?(File.basename(entry))
     #   end
     # 
     #   # Check if path is a valid file.
     #   #
     #   def valid_file?(entry)
     #     ext = File.extname(entry).gsub(/\./, "").downcase
     #     File.file?(source.join(entry)) && EXTENSIONS.include?(ext) && entry !~ IGNORE_FILES
     #   end
     # 
     #   # Render +file+ considering its extension.
     #   #
     #   def render_file(file, plain_syntax = false)
     #     file_format = format(file)
     # 
     #     content = Bookmaker::Syntax.render(root_dir, file_format, File.read(file), plain_syntax)
     # 
     #     content = case file_format
     #     when :markdown
     #       Markdown.to_html(content)
     #     when :textile
     #       RedCloth.convert(content)
     #     else
     #       content
     #     end
     # 
     #     render_footnotes(content, plain_syntax)
     #   end
     # 
     #   def render_footnotes(content, plain_syntax = false)
     #     html = Nokogiri::HTML(content)
     #     footnotes = html.css("p[id^='fn']")
     # 
     #     return content if footnotes.empty?
     # 
     #     reset_footnote_index! unless self.class.footnote_index
     # 
     #     footnotes.each do |fn|
     #       index = self.class.footnote_index
     #       actual_index = fn["id"].gsub(/[^\d]/, "")
     # 
     #       fn.set_attribute("id", "_fn#{index}")
     # 
     #       html.css("a[href='#fn#{actual_index}']").each do |link|
     #         link.set_attribute("href", "#_fn#{index}")
     #       end
     # 
     #       html.css("a[href='#fnr#{actual_index}']").each do |link|
     #         link.set_attribute("href", "#_fnr#{index}")
     #       end
     # 
     #       html.css("[id=fnr#{actual_index}]").each do |tag|
     #         tag.set_attribute("id", "_fnr#{index}")
     #       end
     # 
     #       self.class.footnote_index += 1
     #     end
     # 
     #     html.css("body").inner_html
     #   end
     # 
     #   def format(file)
     #     case File.extname(file).downcase
     #     when ".markdown", ".mkdn", ".md"
     #       :markdown
     #     when ".textile"
     #       :textile
     #     else
     #       :html
     #     end
     #   end
     # 
     #   # Parse layout file, making available all configuration entries.
     #   #
     #   def parse_layout(html)
     #     puts "parse layout."
     #     toc = TOC::HTML.generate(html)
     #     locals = config.merge({
     #       :content   => toc.content,
     #       :toc       => toc.to_html,
     #       :changelog => render_changelog
     #     })
     #     render_template(root_dir.join("templates/html/layout.erb"), locals)
     #   end
     # 
     #   # Render changelog file.
     #   # This file can be used to inform any book change.
     #   #
     #   def render_changelog
     #     changelog = Dir[root_dir.join("text/CHANGELOG.*")].first
     #     return render_file(changelog) if changelog
     #     nil
     #   end
     # 
     #   # Render all +files+ from a given chapter.
     #   #
     #   def render_chapter(files, plain_syntax = false)
     #     String.new.tap do |chapter|
     #       files.each do |file|
     #         chapter << render_file(file, plain_syntax) << "\n\n"
     #       end
     #     end
     #   end
     # end
  end
end