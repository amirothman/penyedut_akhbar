
def get_malaysia_today path="collection/malaysia_today"

  url = 'http://www.malaysia-today.net/feed/'

  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|
      page = item.link



        doc = Nokogiri::HTML(open(page))
        txt = remove_invalid_utf8 doc.css(".shortcode-content").first.text

        txt = txt.gsub(/\(adsbygoogle \= window\.adsbygoogle \|\| \[\]\)\.push\(\{\}\)\;/,'')
        txt = txt.squeeze("\n")
        txt = txt.gsub(/^$/,'')
        # puts "content"
        # puts txt
        # puts "link"
        # puts page
        # puts "date"
        date_string = remove_invalid_utf8 doc.css(".calendar-date").first.text
        # puts date_string
        date = DateTime.parse(date_string)
        date_hash = {year: date.year, month: date.month, day: date.day}
        # puts date_hash
        # puts "title"
        title = doc.css("h2").first.text
        # puts title
        json_hash = {source: "malaysia_today",content: txt, link: page,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: page.gsub(/\W/,'_')}

        puts JSON.pretty_generate(json_hash)
        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end
    end
  end
end
