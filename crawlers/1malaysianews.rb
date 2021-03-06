

def get_1malaysianews path="collection/1malaysianews"

  url = 'http://www.1malaysianews.com/feed/'

  begin
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      feed.items.each do |item|

          # puts item.link
          doc = Nokogiri::HTML(open(item.link))
          content = remove_invalid_utf8 doc.css('#content-area').first.text
          # date_string =
          date = item.pubDate
          date_hash = {year: date.year, month: date.month, day: date.day}
          title = item.title
          json_hash = {source: "1malaysianews", content: content, link: item.link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
          puts JSON.pretty_generate(json_hash)
          File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
            f.write(JSON.pretty_generate(json_hash))
          end
      end
    end
  rescue OpenURI::HTTPError => e
    puts e
  end

end
