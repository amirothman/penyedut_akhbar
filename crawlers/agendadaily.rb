

def get_agendadaily path="collection/agendadaily"

  url = 'http://www.agendadaily.com/feed.html?format=feed&lang=my'

  begin
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|
        begin
            puts item.link
            doc = Nokogiri::HTML(open(item.link))
            content = remove_invalid_utf8 doc.css('.item-page.clearfix').first.text
            # date_string =
            date = item.pubDate
            date_hash = {year: date.year, month: date.month, day: date.day}
            title = item.title
            json_hash = {source: "agendadaily",content: content, link: item.link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
            puts JSON.pretty_generate(json_hash)
            File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
              f.write(JSON.pretty_generate(json_hash))
            end
        rescue URI::InvalidURIError => e
          puts e
        rescue OpenURI::HTTPError => e
          puts e
       end
      end
    end
  rescue OpenURI::HTTPError => e
    puts e
  end
end
