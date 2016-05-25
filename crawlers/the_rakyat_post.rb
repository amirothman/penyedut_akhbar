
def get_the_rakyat_post path="collection/the_rakyat_post"

url = 'http://www.therakyatpost.com/category/news/feed/'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|

    if news_articles.find(:link => item.link).to_a.size > 0
      puts "Article already saved"
    else
      puts item.link
      doc = Nokogiri::HTML(open(item.link))
      content = remove_invalid_utf8 doc.css(".singleContentPadding > p")[1..-2].text
      # puts content
      date_string = doc.css(".singleContentPadding").first.css("p").first.text
      begin
        date = DateTime.parse(date_string)
      rescue ArgumentError => e
        puts e
        date = DateTime.now
      end
      date_hash = {year: date.year, month: date.month, day: date.day}
      title = doc.css(".singleTitle").first.text
      json_hash = {content: content, link: item.link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
      puts JSON.pretty_generate(json_hash)
      File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
        f.write(JSON.pretty_generate(json_hash))
      end

    end
  end
end

end
