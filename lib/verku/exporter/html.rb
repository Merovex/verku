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
            "<div class='section'>#{PandocRuby.markdown(read_content(file)[0]).to_html}</div>"
          end.join("\n\n")
        end
    end
  end
end
