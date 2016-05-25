
def get_malaysian_insider path="collection/malaysian_insider"

url = 'http://www.themalaysianinsider.com/rss/malaysia'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|
    begin
    # if news_articles.find(:link => item.link).to_a.size > 0
    #   puts "Article already saved"
    # else
      # puts item.link
      doc = Nokogiri::HTML(open(item.link))
      content = remove_invalid_utf8 doc.css("article").first.text
      date_string = doc.css(".datetime").first.text
      date = DateTime.parse(date_string)
      date_hash = {year: date.year, month: date.month, day: date.day}
      title = doc.css("h1").first.text
      json_hash = {source:"malaysian_insider",content: content, link: item.link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
      puts JSON.pretty_generate(json_hash)
      File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
        f.write(JSON.pretty_generate(json_hash))
      end
    # end
    rescue Errno::ETIMEDOUT => e
      puts e
    end
  end
end

end
