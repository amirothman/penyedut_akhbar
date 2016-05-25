

def get_malaysiakini path="collection/malaysiakini"

url = 'http://news.google.com/news?hl=en&gl=us&q=malaysiakini&um=1&ie=UTF-8&output=rss'

open(url) do |rss|
  feed = RSS::Parser.parse(rss)
  feed.items.each do |item|
    begin
      # puts "===="
      link = item.link.gsub(/^.+url\=/,'')
      # puts "content"



        doc = Nokogiri::HTML(open(link))
        content = remove_invalid_utf8 doc.css('.mk-content-text.local-content-body').first.text
        content = content.gsub(/If\syou're\salready\sa\ssubscriber,\splease\sSign\sin.\nSign\sin\sSubscribe\snow/,'')
        content = content.gsub(/For\sthe\srest\sof\sthis\sstory\sand\smore,\ssubscribe\sfor\sonly\sRM150\sa\syear./,'')
        # puts content
        # puts "link"
        puts link
        # puts "date"
        # date_string = doc.css("#slcontent3_4_sleft_0_pDate").text
        date = item.pubDate
        date_hash = {year: date.year, month: date.month, day: date.day}
        # puts date_hash
        # puts "title"
        title = item.title.gsub(/Malaysiakini/,'')
        title = title.gsub(/\s-\s*\(subscription\)/,'')
        # puts title

        json_hash = {source: "malaysiakini",content: content, link: link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: link.gsub(/\W/,'_')}
        puts JSON.pretty_generate(json_hash)
        File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
          f.write(JSON.pretty_generate(json_hash))
        end
    rescue ArgumentError => e
      puts e
    end
  end
end

end
