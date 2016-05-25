

def get_malaysia_chronicle path="collection/malaysia_chronicle"

  url = 'http://www.malaysia-chronicle.com/index.php?option=com_k2&view=itemlist&format=feed&type=rss&Itemid=2'

  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|
      begin

        # if news_articles.find(:link => item.link).to_a.size > 0
        #   puts "Article already saved"
        # else
          doc = Nokogiri::HTML(open(item.link))
          content = remove_invalid_utf8 doc.css(".itemFullText").text

          date_string = doc.css(".itemDateCreated").first.text
          date = DateTime.parse(date_string)
          date_hash = {year: date.year, month: date.month, day: date.day}
          # puts date_hash

          # puts "title"
          title = doc.css("h2.itemTitle").first.text
          # puts title
          json_hash = {content: content, link: item.link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
          puts JSON.pretty_generate(json_hash)
          File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
            f.write(JSON.pretty_generate(json_hash))
          end
        # end
      rescue URI::InvalidURIError => e
        puts e
      end
    end
  end

end
