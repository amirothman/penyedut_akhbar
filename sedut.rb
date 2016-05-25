require 'rss'
require 'open-uri'
require 'nokogiri'
require 'json'
require 'date'

Dir["crawlers/*.rb"].each {|file| require_relative file }

puts "1malaysianews"
# get_1malaysianews

puts "agendadaily"
# get_agendadaily
# puts "astro_awani"
# puts "bernama"
# get_bernama
#
# puts "free_malaysia_today"
# get_free_malaysia_today
#
# puts "harakah"
# get_harakah

puts "malaysia_chronicle"
get_malaysia_chronicle

puts "malaysia_edition"
get_malaysia_edition

puts "malaysia_today"
get_malaysia_today

puts "malaysiakini"
get_malaysiakini

puts "malaysian_insider"

get_malaysian_insider

puts "malaysianreserve"

get_malaysianreserve

puts "mykmu"

get_mykum

puts "nst"

get_nst

puts "the_ant_daily"
get_the_ant_daily

puts "the_rakyat_post"
get_the_rakyat_post

puts "the_star"
get_the_star

puts "the_sun"
get_the_sun

puts "theheatmalaysia"
get_theheatmalaysia

puts "topic_malaysia"
get_topix_malaysia

puts "utusan"
get_utusan
