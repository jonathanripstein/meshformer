# by Jonathan Ripstein
# July 24, 2014
#
#
# hopefully this program will be able to interact with the Meshbrowser website

require 'open-uri'
require 'nokogiri'

#get open the Meshbrowser site and retrive a ID for a tag
def open_url(tag)
	
	#allows the program to use 2 part tags
	if tag.match(" ")
			tag = tag.gsub(" ","%20")
	end
	
	#open the url
	url = "https://www.nlm.nih.gov/cgi/mesh/2014/MB_cgi?term=" + tag
	# a check for opening the url
	/if open(url).read
			 yes
	end/
	
	# parse the webpage using nokogiri
	doc = Nokogiri::HTML(open(url)) do |config|
		config.noblanks
	end

	# search for the table on Meshbrowser webpage
	info = doc.xpath("//body//table//tr")
	
	# a program check here puts the contents of the table at space 4 
	puts info[3].content
	
	# the next section of code finds the Unique ID content in the table
	# I cannot figgure out how to directly search for the ID or to call the /td value associated with this match
	th = info.xpath("//th")
	id =  th.select{|tr| 
		tr.content == "Unique ID"
	}
	puts id
	
	# Bellow are some atempts to get the Unique ID # none of which worked
	puts 
	puts

	#puts info.select{|line|
	#	line.at_xpath("//th") == id
	#}
	#info.each do |line|
	#	th = line.xpath("//th")
	#	if th.select{|tr| tr.content == "Unique ID"} !=nil
	#		puts line
	#	end	
	#
	#end/

	


end
# to start with a simplified array of what will be the meshtags after reading the .csv file of them
meshtags = [["Abdominal pain", "Croup"],["Child, Preschool"]]
puts meshtags

# opens the meshbrowser page for each Meshterm
meshtags.each do |resource|
	resource.each do |tag|
		open_url(tag)
	end
end

