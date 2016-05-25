

def get_the_sun path="collection/the_sun"

url = 'http://www.thesundaily.my/rss/local'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|

    # if news_articles.find(:link => item.link).to_a.size > 0
    #   puts "Article already saved"
    # else
      # puts item.link
      doc = Nokogiri::HTML(open(item.link))
      content = remove_invalid_utf8 doc.css('#content').first.text
      date_string = doc.css('.submitted').first.text
      date = DateTime.parse(date_string)
      date_hash = {year: date.year, month: date.month, day: date.day}
      title = doc.css('#page-title').first.text
      json_hash = {source:"the_sun",content: content, link: item.link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
      puts JSON.pretty_generate(json_hash)
      File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
        f.write(JSON.pretty_generate(json_hash))
      end

    # end
  end
end

end
