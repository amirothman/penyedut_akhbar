

def get_astro_awani path="collection/astro_awani"

  url = 'http://feeds.astroawani.com/c/35153/f/652026/index.rss'

  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|

      if news_articles.find(:link => item.link).to_a.size > 0
        puts "Article already saved"
      else
        puts item.link
        doc = Nokogiri::HTML(open(item.link))
        # content =
        # date_string =
        date = DateTime.parse(date_string)
        date_hash = {year: date.year, month: date.month, day: date.day}
        # title =
        json_hash = {content: content, link: item.link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year}
        json = JSON.pretty_generate(json_hash)
        puts JSON.pretty_generate(json_hash)
        #news_articles.insert_one(json_hash)
        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end
      end
    end
  end

end
