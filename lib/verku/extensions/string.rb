class String
  def to_permalink
    str = ActiveSupport::Multibyte::Chars.new(self.dup)
    str = str.normalize(:kd).gsub(/[^\x00-\x7F]/,'').to_s
    str.gsub!(/[^-\w\d]+/xim, "-")
    str.gsub!(/-+/xm, "-")
    str.gsub!(/^-?(.*?)-?$/, '\1')
    str.downcase!
    str
  end
  def fix_scenebreaks
    str = ActiveSupport::Multibyte::Chars.new(self.dup)
    str.gsub('\begin{center}\rule{0.5\linewidth}{\linethickness}\end{center}','\pfbreak')
  end
  def sectionize
    str = ActiveSupport::Multibyte::Chars.new(self.dup)
    "<div class='section'>#{str}</div>"
  end
  # def to_latex(headers=nil)
  #   headers = %w{chapter section subsection subsubsection paragraph subparagraph} if headers.nil?
  # 	require 'kramdown'
  # 	s = Kramdown::Document.new(self.dup, :latex_headers => headers).to_latex
  #   s << "\\pbreak{}"
  # end
  # def to_html
  # 	require 'kramdown'
  # 	Kramdown::Document.new(self.dup).to_html
  # end
end
