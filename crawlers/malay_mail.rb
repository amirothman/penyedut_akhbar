

def get_malay_mail path="collection/malay_mail"

  url = 'http://www.themalaymailonline.com/feed/rss/malaysia'

  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|

      if news_articles.find(:link => item.link).to_a.size > 0
        puts "Article already saved"
      else
        puts item.link
        doc = Nokogiri::HTML(open(item.link))
        content = remove_invalid_utf8 doc.css(".article-content").first.text
        # date_string =
        date = DateTime.now
        date_hash = {year: date.year, month: date.month, day: date.day}
        title = doc.css(".headlines").first.text
        json_hash = {source:"malay_mail",content: content, link: item.link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
        puts JSON.pretty_generate(json_hash)
        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end
        # id = news_articles.insert_one(json_hash)

        # File.open("../temp_data/inserted_ids","a") do |f|
        #   f.write("#{id.inserted_id}\n")
        # end
      end
    end
  end

end
