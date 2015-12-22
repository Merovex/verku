class Fixnum
  def day
    self * (60 * 60 * 24) # seconds * hours * minutes
  end
  def ago
    Time.now - self
  end
end
require 'json'
module Bookmaker
  class Stats
    attr_reader :root_dir

    def initialize(root_dir)
      @root_dir = root_dir
      @files = Dir["#{root_dir}/text/**/[0-9]*.tex"]
      @words = 0
      @progress = (File.exist?(log)) ? JSON.parse(File.open(log,'r').read).clone : {}
    end

    def log
      "#{root_dir}/.wordcount"
    end

    def target
      Bookmaker.config(@root_dir)['wordcount']
    end
    def now
      Date.today.to_s
    end
    def words
      if @words == 0
        most_recent = @files.max_by {|f| File.mtime(f)}
        if !@progress[now].nil? and File.mtime(log) > File.mtime(most_recent)
          @progress[now]
        else
          detex = "/usr/texbin/detex"

          file = Tempfile.new('foo.tex')
          file.write(text)
          file.close
          @progress[now] = `detex #{file.path}| wc -w`.to_i
          file.unlink
          # Do previous day's progress...if nil.
          @progress[Date.yesterday.to_s] = @progress[now] if @progress.keys.count == 1
        end
      end
      if (lasttime != Date.yesterday.to_s)
        # Update the record.
        n = lasttime
        w = @progress[lasttime]
        n.upto(Date.yesterday.to_s) do |k|
          # puts "Upto #{k}: @progress[#{k}] = #{w}"
          @progress[k] = w
        end
      end
      File.open(log,'w').write( JSON.generate(@progress) )
      @words = @progress[now]
    end
    def lasttime
      p = nil
      @progress.keys.sort.each do |k|
        break if k == now
        p = k
      end
      p
    end
    def yesterday
      @progress[lasttime]
    end
    def today
      @words - @progress[lasttime] 
    end
    def text
      @text = nil
      @text = @files.map{|f| File.open(f,'r').read}.join("\n\n\n") if @text.nil?
    end
    def remaining
      target - words
    end

    # def html
    #   @html ||= Nokogiri::HTML(content)
    # end

    # def words
    #   @words ||= text.split(" ").size
    # end

    # def chapters
    #   @chapters ||= html.css(".chapter").size
    # end

    # def images
    #   @images ||= html.css("img").size
    # end

    # def footnotes
    #   @footnotes ||= html.css("p.footnote").size
    # end

    # def links
    #   @links ||= html.css("[href^='http']").size
    # end

    # def code_blocks
    #   @code_blocks ||= html.css("pre").size
    # end

    # def content
    #   @content ||= Parser::HTML.new(root_dir).content
    # end
  end
end
