require 'kramdown'
require "awesome_print"

module Verku
  class Exporter
    class HTML < Base
      def export!
        locals = config.merge({ :contents => content })
        locals['copyright'].gsub!("(C)", "&copy;")
        output = render_template(root_dir.join("_templates/html/layout.erb"), locals)
        File.open(root_dir.join(html_file), 'w').write(output)
        true

      rescue Exception => error
        handle_error(error)
        false
      end

      private
        def content
          content = String.new
          source_list.each_chapter do |files|
            content << render_chapter(files)
          end
          return content
        end
        def render_file(file)
          data = read_content(file)
          content = "#{data[0]}".to_html
          return content
        end
        def render_chapter(files)
          chapter = String.new
          String.new.tap do
            files.each do |file|
              chapter << render_file(file) << "\n\n"
            end
          end
          return "<div class='chapter'>\n\t#{chapter}\n</div>"
        end
        def html_file
          root_dir.join("builds/#{name}.html")
        end
    end
  end
end
