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
  def to_latex(headers=nil)
    headers = %w{part chapter section subsection subsubsection paragraph} if headers.nil?
    # headers = headers[0..5]
  	require 'kramdown'
  	s = Kramdown::Document.new(self.dup, :latex_headers => headers).to_latex
    s << "\\pbreak{}"
  end
  def to_html
  	require 'kramdown'
  	Kramdown::Document.new(self.dup).to_html
  end
end
