

def get_the_star path="collection/the_star"

  url = 'http://www.thestar.com.my/rss/news/nation/'
  open(url) do |rss|
    feed = Nokogiri::XML(rss)
    feed.css("item").each do |item|

      begin
      # puts "===="
      link = item.css("link").first.text
      # puts "content"


        doc = Nokogiri::HTML(open(link))
        content = remove_invalid_utf8 doc.css("#slcontent3_4_sleft_0_storyDiv").text
        # puts content
        # puts "link"
        # puts link
        # puts "date"
        date_string = doc.css("#slcontent3_4_sleft_0_pDate").text
        # date = DateTime.parse(date_string)
        date = item.pubDate
        date_hash = {year: date.year, month: date.month, day: date.day}
        # puts date_hash
        # puts "title"
        title = doc.css(".headline").first.text
        # puts title

        json_hash = {source: "the_star",content: content, link: link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: link.gsub(/\W/,'_')}
        puts JSON.pretty_generate(json_hash)
        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end
    rescue ArgumentError => e
      puts e
    end
    end
    # feed.items.each do |item|

    # end
  end
end
