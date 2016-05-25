

def get_the_ant_daily path="collection/the_ant_daily"

url = 'http://www.theantdaily.com/RSS.aspx'

links = Nokogiri::XML(open(url)).xpath("//link")
links.drop(1).each do |link|
  link = link.text

  # if news_articles.find(:link => link).to_a.size > 0
  #   puts "Article already saved"
  # else
    puts link
    doc = Nokogiri::HTML(open(link))
    content = remove_invalid_utf8 doc.css(".article-content-middle").first.text
    date_string = doc.css('#cphBody_lblArticleDate').first.text
    date = DateTime.parse(date_string)
    date_hash = {year: date.year, month: date.month, day: date.day}
    title = doc.css('#cphBody_lblArticleTitle').first.text
    json_hash = {source:"the_ant_daily",content: content, link: link,title: title, month: date.month,day: date.day,year: date.year, pseudo_id: link.gsub(/\W/,'_')}
    puts JSON.pretty_generate(json_hash)
    File.open("#{path}/#{json_hash[:pseudo_id]}.json","w") do |f|
      f.write(JSON.pretty_generate(json_hash))
    end
  # end
end

end
