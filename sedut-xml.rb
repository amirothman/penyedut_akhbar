require 'rss'
require 'open-uri'
require 'nokogiri'
require 'mongo'
require 'json'

Mongo::Logger.logger.level = ::Logger::FATAL
client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'news_visualizer')

news_articles = client[:news_articles]

url = 'http://themalaysianreserve.com/new/rss.xml'

begin

  rss = Nokogiri::HTML(open(url))

  puts rss.xpath("//item").size
  puts rss.xpath("//link").size
  puts rss.xpath("//pubDate").size
  puts rss.xpath("//title").size
  puts rss.xpath("//link").size
  
      # title = item.css("title").first
      # link = item.css("link").first
      # date_string = item.css("pubDate").first
      # puts title
      # puts link
      # puts date_string
      # date = DateTime.parse(date_string)

      # json_hash = {content: content, 
      #              link: link, 
      #              date: date_hash,
      #              title: title, 
      #              month: date.month,
      #              day: date.day,
      #              year: date.year, 
      #              pseudo_id: item.link.gsub(/\W/,'_')}
      # puts JSON.pretty_generate(json_hash)

  # open(url) do |rss|
  #   feed = RSS::Parser.parse(rss)
  #   feed.items.each do |item|

  #     if news_articles.find(:link => item.link).to_a.size > 0
  #       puts "Article already saved"
  #     else
  #       puts item.link
  #       doc = Nokogiri::HTML(open(item.link))
  #       # content =
  #       # date_string =
  #       # date = DateTime.parse(date_string)
  #       date = item.pubDate
  #       date_hash = {year: date.year, month: date.month, day: date.day}
  #       title = item.title
  #       json_hash = {content: content, link: item.link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: item.link.gsub(/\W/,'_')}
  #       puts JSON.pretty_generate(json_hash)
  #       # id = news_articles.insert_one(json_hash)
  #       #
  #       # File.open("../temp_data/inserted_ids","a") do |f|
  #       #   f.write("#{id.inserted_id}\n")
  #       # end
  #     end
  #   end
  # end
rescue OpenURI::HTTPError => e
  puts e
end
