
def get_nst path="collection/nst"

url = 'http://www.nst.com.my/latest.xml'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|
    # puts "===="
    # puts "content"


    if news_articles.find(:link => item.link).to_a.size > 0
      puts "Article already saved"
    else
      doc = Nokogiri::HTML(open(item.link))
      content = remove_invalid_utf8 doc.css('.node-article').first.text.gsub(/\d+ reads/,'')
      # puts content
      # puts "link"
      # puts item.link
      # puts "date"
      date_string = doc.css(".node-published-date").first.text
      date = DateTime.parse(date_string)
      date_hash = {year: date.year, month: date.month, day: date.day}
      # puts "title"
      title = doc.css(".node-title").first.text
      # puts title
      json_hash = {content: content, link: item.link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
      puts JSON.pretty_generate(json_hash)
      File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
        f.write(JSON.pretty_generate(json_hash))
      end
    end
  end
end
end
