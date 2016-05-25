
def get_malaysia_edition path="collection/malaysia_edition"

url = 'http://feeds.feedburner.com/MalaysiaEdition'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|

    if news_articles.find(:link => item.link).to_a.size > 0
      puts "Article already saved"
    else
      doc = Nokogiri::HTML(open(item.link))
      content = remove_invalid_utf8 doc.css(".entry").first.text
      # date_string =
      date = item.pubDate
      date_hash = {year: date.year, month: date.month, day: date.day}
      title = item.title
      json_hash = {content: content, link: item.link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
      puts JSON.pretty_generate(json_hash)
      File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
        f.write(JSON.pretty_generate(json_hash))
      end
    end
  end
end

end
