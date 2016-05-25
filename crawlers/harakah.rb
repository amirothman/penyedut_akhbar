

def get_harakah path="collection/harakah"
  url = 'http://www.harakahdaily.net/index.php?format=feed&type=rss'

  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|


        # puts item.link
        doc = Nokogiri::HTML(open(item.link))
        content = remove_invalid_utf8 doc.css(".content").first.text
        # print content
        date_string = doc.css("time").first.text
        # puts date_string
        date = DateTime.parse(date_string)
        date_hash = {year: date.year, month: date.month, day: date.day}
        title = doc.css(".title").first.text
        # puts title
        json_hash = {source: "harakah", content: content, link: item.link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
        puts JSON.pretty_generate(json_hash)
        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end
    end
  end

end
