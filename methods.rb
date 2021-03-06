require 'rubygems'
require 'nokogiri'
require 'open-uri'

def pop_ar_sei(url, r)
	page = Nokogiri::HTML(open(url))
	shows = page.css('table:nth-child(4) .borderClass:nth-child(2) > a')
	roles = page.css('.borderClass~ .borderClass+ .borderClass > a')
	zipped = Array.new(shows.length)
	i = 0
	shows.zip(roles).each do |x,y|
		i += 1
		zipped[i] = x.text + ' - ' +  y.text
	end
	list = Array.new()
	for i in 0..(shows.length - 1) do
		list[i] = shows[i].text
	end
	r ||= 1
	if r == 1 then
		ret = zipped
	else
		ret = list
	end
	return ret
end

def pop_ar_mal(un)
	url = 'http://myanimelist.net/malappinfo.php?u='+ un + '&status=all&type=anime'
	page = Nokogiri::HTML(open(url))
	mal = page.xpath("//series_title")
	smal = Array.new()
	for i in 0..(mal.length - 1) do
		smal[i] = mal[i].text
	end
	smal = smal.sort
	return smal
end

def pop_ar_col(url, un)
	mal = Array.new()
	sei = Array.new()
	inv = Array.new()
	col = Array.new()
	mal = pop_ar_mal(un)
	sei = pop_ar_sei(url, 2)
	inv = sei - mal
	col = sei - inv
	return col
end

puts pop_ar_col('http://myanimelist.net/people/599/Aki_Toyosaki', 'quixten')
