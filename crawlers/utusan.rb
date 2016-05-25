


def get_utusan path="collection/utusan"

url = 'http://page2rss.com/rss/0840bc5d5b377dc76c49f9ea4af7b52f'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.drop(2).each do |item|
    # puts item.link

    title = item.title

    date = item.pubDate
    date_hash = {year: date.year, month: date.month, day: date.day}
    doc = Nokogiri::HTML(open(item.link))
    link = doc.css("h2 > a")[1].attr("href")
    if news_articles.find(:link => link).to_a.size > 0
      puts "Article already saved"
    else
      # puts link
      doc = Nokogiri::HTML(open(link))
      content = remove_invalid_utf8 doc.css(".element.article").first.text
      json_hash = {content: content, link: link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: link.gsub(/\W/,'_')}
      puts JSON.pretty_generate(json_hash)
      File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
        f.write(JSON.pretty_generate(json_hash))
      end
    end
  end
end

end
