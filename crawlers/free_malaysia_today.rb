


def get_free_malaysia_today path="collection/free_malaysia_today"

  url = 'http://www.freemalaysiatoday.com/feed/'

  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|


        # puts item.link
        doc = Nokogiri::HTML(open(item.link))
        content = remove_invalid_utf8 doc.css(".storycontent-post").first.text
        date_string = doc.css(".meta").first.text
        date = DateTime.parse(date_string)
        date_hash = {year: date.year, month: date.month, day: date.day}
        title = doc.css("h1").text
        # puts title
        json_hash = {source:"free_malaysia_today",content: content, link: item.link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
        puts JSON.pretty_generate(json_hash)

        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end

    end
  end

end
