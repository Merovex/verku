module Verku
  class Exporter
    class HTML < Base
      def export!
        locals = config.merge({ "contents" => content })
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
          source_list.map do |file|
            d = File.read_content(file)
            # raise d.inspect
            Kramdown::Document.new(
              read_content(file)[0],
              :latex_headers => %w{chapter section subsection subsubsection paragraph subparagraph}
            ).to_html
            # PandocRuby.markdown(read_content(file)[0]).to_html.sectionize
          end.join("\n\n")
        end
    end
  end
end
