require 'fileutils'
module Bookmaker
  module Parser
    class Epub < Base
      def sections
        @sections ||= html.css("div.chapter").each_with_index.map do |chapter, index|
          OpenStruct.new({
            :index    => index,
            :filename => "section_#{index}.html",
            :filepath => tmp_dir.join("section_#{index}.html").to_s,
            :html     => Nokogiri::HTML(chapter.inner_html)
          })
        end
      end
      def epub; @epub ||= EeePub.make ;end
      def html; @html ||= Nokogiri::HTML(html_path.read); end
      def parse
        puts "-- Exporting EPUB"
        epub.title        config["title"]
        epub.language     config["language"]
        epub.creator      config["authors"].to_sentence
        epub.publisher    config["publisher"]
        epub.date         config["published_at"]
        epub.uid          config["uid"]
        epub.identifier   config["identifier"]["id"], :scheme => config["identifier"]["type"]
        if cover_image.nil?
          puts "   - Consider adding a cover images in /images."
        else
          epub.cover      cover_image
        end
        write_coverpage!
        write_thankspage!
        write_copyright!
        write_sections!
        write_backpage!
        write_toc!
        epub.files    cover_page + thanks_page + sections.map(&:filepath) + back_page + copyright_page + assets
        epub.nav      navigation

        epub.save(epub_path)
        true
      rescue Exception
        p $!, $@
        false
      end
      def back_page
        return Dir[back_path] if File.exist?(back_path)
        []
      end
      def cover_page
        Dir[cover_path]
      end
      def copyright_page
        Dir[copyright_path]
      end
      def thanks_page
        Dir[thanks_path]
      end
      def write_backpage!
        contents = render_template(root_dir.join("templates/epub/back.html"), config)
        File.open(back_path,"w") do |file|
          file << contents
        end
      end
      def write_coverpage!
        contents = render_template(root_dir.join("templates/epub/cover.html"), config)
        puts "Writing cover page. #{cover_path}"
        # 
        # raise File.dirname(cover_path).inspect
        FileUtils.mkdir_p(File.dirname(cover_path))
        File.open(cover_path,"w") do |file|
          file << contents
        end
      end
      def write_copyright!
        contents = render_template(root_dir.join("templates/html/copyright.erb"), config)
        # File.open('help.html','w').write(contents)
        FileUtils.mkdir_p(File.dirname(copyright_path))
        File.open(copyright_path,"w") do |file|
          file << contents
          # puts file
        end
      end
      def write_thankspage!
        contents = render_template(root_dir.join("templates/html/thanks.erb"), config)
        # File.open('help.html','w').write(contents)
        FileUtils.mkdir_p(File.dirname(thanks_path))
        File.open(thanks_path,"w") do |file|
          file << contents
          # puts file
        end
      end
      def write_toc!
        toc = TOC::Epub.new(navigation)
        FileUtils.mkdir_p(File.dirname(toc_path))
        File.open(toc_path, "w") do |file|
          file << toc.to_html
        end
      end

      def write_sections!
        # First we need to get all ids, which are used as
        # the anchor target.
        links = sections.inject({}) do |buffer, section|
          section.html.css("[id]").each do |element|
            anchor = "##{element["id"]}"
            buffer[anchor] = "#{section.filename}#{anchor}"
          end

          buffer
        end

        # Then we can normalize all links and
        # manipulate other paths.
        #
        sections.each do |section|
          section.html.css("a[href^='#']").each do |link|
            href = link["href"]
            link.set_attribute("href", links.fetch(href, href))
          end

          # Replace all srcs.
          #
          section.html.css("[src]").each do |element|
            src = File.basename(element["src"]).gsub(/\.svg$/, ".png")
            element.set_attribute("src", src)
            element.set_attribute("alt", "")
            element.node_name = "img"
          end

          FileUtils.mkdir_p(tmp_dir)
          File.open(section.filepath, "w") do |file|
            body = section.html.css("body").to_xhtml.gsub(%r[<body>(.*?)</body>]m, "\\1")
            file << render_chapter(body)
          end
        end
      end
      def render_chapter(content)
        locals = config.merge(:content => content)
        render_template(template_path, locals)
      end
      def assets
        @assets ||= begin
          assets = Dir[root_dir.join("templates/epub/*.css")]
          assets += Dir[root_dir.join("images/**/*.{jpg,png,gif}")]
          assets
        end
      end
      def cover_image
        path = Dir[root_dir.join("images/cover-#{name}.{jpg,png,gif}").to_s.downcase].first
        return File.basename(path) if path && File.exist?(path)
      end
      def navigation
        sections.map do |section| {
            :label => section.html.css("h2:first-of-type").text,
            :content => section.filename
          }
        end
      end
      def template_path
        root_dir.join("templates/epub/page.erb")
      end
      def html_path
        root_dir.join("output/#{name}.html")
      end
      def epub_path
        root_dir.join("output/#{name}.epub")
      end
      def tmp_dir
        root_dir.join("output/tmp")
      end
      def cover_path
        tmp_dir.join("cover.html")
      end
      def thanks_path
        tmp_dir.join("thanks.html")
      end
      def back_path
        tmp_dir.join("back.html")
      end
      def copyright_path
        tmp_dir.join("copyright.html")
      end
      def toc_path
        tmp_dir.join("toc.html")
      end
    end
  end
end