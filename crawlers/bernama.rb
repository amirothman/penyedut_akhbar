
def get_bernama path="collection/bernama"

  url = 'http://www.bernama.com/bernama/v8/rss/english.php'

  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|

      # if news_articles.find(:link => item.link).to_a.size > 0
      #   puts "Article already saved"
      # else
        link = item.link.gsub(/v7/,'v8')
        doc = Nokogiri::HTML(open(link))
        content = remove_invalid_utf8 doc.css(".NewsText").first.text

        date = DateTime.now
        date_hash = {year: date.year, month: date.month, day: date.day}
        title = doc.css("h1").first.text
        json_hash = {source:"bernama",content: content, link: link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: link.gsub(/\W/,'_')}
        puts JSON.pretty_generate(json_hash)
        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end
      # end
    end
  end

end
