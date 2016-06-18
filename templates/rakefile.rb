require 'awesome_print'
require 'json'
require 'tempfile'

if true
  require 'cli-colorize'
  cli = true
end

desc "Make copies via git to remote Repositories"
task :archive do
   puts "## Archival Branch to Repositories!"
     system "git add -A ."
     puts "\n## Commiting: Site updated at #{Time.now.utc}"
     message = "Project updated at #{Time.now.utc}"
     system "git commit -m \"#{message}\""
     ["github", "bitbucket"].each do |remote|
         puts "\n## Pushing to **#{remote}** website"
         system "git push #{remote} master"
     end
     puts "\n## Archival complete"
end
desc "Find a word in the text files. Good for error finding.."
task :find, :item do |t, args|
    c = "find text -type f |xargs grep -l '#{args[:item]}'"
    system c
end
desc "Show a word in context. Good for error finding.."
task :show, :item do |t, args|
    c = "find text -type f |xargs grep  --color=auto '#{args[:item]}'"
    system c
end
task :findc, :item do |t, args|
    c = "find text -type f -name \"*#{args[:item]}*\""
    system c
end

desc "Compile PDF and display."
task :preview do
    puts "## Creating another craptacular preview for your viewing pleasure."
    puts "## Give me a second to start as looking at this stuff makes me puke."
    system "verku compile --only pdf;"
    pdf = Dir.glob("output/*.pdf").first
    system "open #{pdf}" unless pdf.nil?
end
task :progress do
  log_file = "../../writing.log"
  if (!File.exist?(log_file))
    puts "You don't have a log file."
    return
  end
  j = JSON.parse(File.open(log_file,'r').read)
  # puts j.inspect
  s = j[Date.today.prev_day.strftime('%Y-%m-%d')]
  progress = s[File.basename(Dir.pwd)]
  text = Dir["text/**/[0-9]*.tex"].map{|f| File.open(f,'r').read}.join("\n\n\n")

  file = Tempfile.new('foo.tex')
  file.write(text)
  file.close
  today = `detex #{file.path}| wc -w`.to_i
  file.unlink
  target = (500.0 * (300.0 / 365.0)).to_i
  delta = today - progress
  puts "So far today: #{today} - #{progress} = #{delta} (#{delta / 333} & #{progress/333} pages) (Target: #{delta - target}) - #{Time.now}}"
end
task :wc, :target do |t, args|
    files = Dir["text/**/[0-9]*.tex"]
    detex = "/usr/texbin/detex"

    counts = {}
    total = 0
    sections = 0
    chapters = {}
    files.each do |f|
      next if !args[:target].nil? and !f.include?(args[:target])
      counts[f] = `detex #{f} | wc -w`.to_i
      chapter = File.dirname(f)
      chapters[chapter] = chapters.fetch(chapter,0) + counts[f]
      total += counts[f]
      if cli
        case
          when counts[f] == 0 then
            next
          when counts[f] > 1500 then
            puts CLIColorize.safe_colorize("...counting #{f} : #{counts[f]}", :yellow)
          when counts[f] < 1000 then
            puts CLIColorize.safe_colorize("...counting #{f} : #{counts[f]}", :red)
          else
            puts CLIColorize.safe_colorize("...counting #{f} : #{counts[f]}", :green)
        end
      else
        next if counts[f] == 0
        puts "...counting #{f} : #{counts[f]}"
      end
      sections += 1
    end
    # sections = 1 if sections == 0
    puts "Total: #{total} (#{sections} sections). Average #{total/(sections || 1)}"

    # chapters.keys.each {|k| chapters[k] /= 1}
    # ap chapters
end