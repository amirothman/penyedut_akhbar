require 'rss'
require 'open-uri'
require 'nokogiri'
require 'json'
require_relative 'util'

url = 'http://www.nst.com.my/latest.xml'

begin
  open(url) do |rss|
    feed = RSS::Parser.parse(rss)
    feed.items.each do |item|

      if news_articles.find(:link => item.link).to_a.size > 0
        puts "Article already saved"
      else
        puts item.link
        doc = Nokogiri::HTML(open(item.link))
        # content =
        # date_string =
        # date = DateTime.parse(date_string)
        date = item.pubDate
        date_hash = {year: date.year, month: date.month, day: date.day}
        title = item.title
        json_hash = {content: content, link: item.link, date: date_hash,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
        puts JSON.pretty_generate(json_hash)
        # id = news_articles.insert_one(json_hash)
        #
        # File.open("../temp_data/inserted_ids","a") do |f|
        #   f.write("#{id.inserted_id}\n")
        # end
      end
    end
  end
rescue OpenURI::HTTPError => e
  puts e
end
