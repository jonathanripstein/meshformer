# find_meshid3
#
# Created by Jonathan Ripstein August 8th 2014
# 
# hopefully this program will be able to interact with the Meshbrowser website to allow automated retrival
# of Unique MeshID #'s from the Mesh term
# the program requires that you have all mesh terms in a file new_mesh_array_terms.csv (output from external_resources.rb)
# the program will output a file new_tags.txt that can be used by the meshformer program
# the program also requires an internet connection



require 'open-uri'
require 'csv'

#get open the Meshbrowser site and retrive a ID for a tag
def open_url(tag)
	
	#allows the program to use 2 part tags
	if tag.match(" ")
			tag = tag.gsub(" ","%20")
	end
	
	#create the url
	url = "https://www.nlm.nih.gov/cgi/mesh/2014/MB_cgi?term=" + tag

	# read the url
	file = open(url).read

	#index Unique ID in the file
	x = file.index('Unique ID')

	#returns nil if no Unique ID is found
	if (x==nil)
		return ("nil")
	end

	# a check for the above line
	# puts "found Unique ID at position #{x} from #{tag}"

	# write the important part of the webpage to an array 
	count = 28
	array = []
	7.times do
		array.push(file[x + count])
		count += 1
	end
	
	return (array.join)
end



# meshtags from the .csv file of them
	#open the file
	meshtags = CSV.read("new_mesh_array_terms.csv")

	puts meshtags

# creates an array to save the tags and IDs
tags_and_id = []

# opens the meshbrowser page for each Meshterm finds the unique id and writes the Mesh term
# and the ID to the array
meshtags.each do |resource|
	resource.each do |tag|
		tag = tag.strip
		tags_and_id.push([tag, open_url(tag)])
	end
end


# a check to make sure the array is arranged and created corectly 
puts tags_and_id [1]

#saves it to a file
  File.open("new_tags.txt", "w") do |file|
        tags_and_id.each do |line|
        	file.write("#{line[1]}, \"#{line[0]}\"")
        	file.write("\r\n")
        end 
    end


