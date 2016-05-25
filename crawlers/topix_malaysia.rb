

def get_topix_malaysia path="collection/topix_malaysia"

url = 'http://www.topix.com/rss/world/malaysia'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|

    # if news_articles.find(:link => item.link.gsub(/\?fromrss=1/,'')).to_a.size > 0
    #   puts "Article already saved"
    # else
      begin
        link = item.link.gsub(/\?fromrss=1/,'')
        doc = Nokogiri::HTML(open(link))
        content = remove_invalid_utf8 doc.css(".snippet.str-snippet > p").first.text
        date_string = doc.css(".x-time").text
        if date_string.match(/hrs ago/)
          date = DateTime.now
        elsif date_string.match(/Yesterday/)
          date = DateTime.now - 1
        else
          date = DateTime.parse(date_string)
        end
        date_hash = {year: date.year, month: date.month, day: date.day}
        title = doc.css(".permheader").first.text
        json_hash = {source: "topix_malaysia",content: content, link: link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: link.gsub(/\W/,'_')}
        puts JSON.pretty_generate(json_hash)
        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end

      rescue ArgumentError => e
        puts e
      end

    # end

  end
end

end
