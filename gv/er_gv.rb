# Credits Jonathan Ripstein
# Modifications Greg Van de Mosselaer
#
# This program should ideally start by reading in a excel document.csv 
# with external_resource information for the trekk site. It then creates 
# an array to store the information and outputs a new .csv file with all 
# the meshtags that were referenced. It uploads the current meshtags from 
#existing_tags.yml and outputs tags from the file that are not currently in 
# use by trekk at new_mesh_array_terms.csv 

# The first section of the program will upload an excel document.csv as an array 
# with headings

require 'csv'
puts 'Enter the .cvs external_resources file (ie "PEM_db.cvs")'
puts '> '
external_resourcesfile = gets.chomp


#open the file
external_resources = CSV.read(external_resourcesfile, headers:true)


# the following code creates an array meshterms from the upload document
# the new array for meshterms
meshtags = []
#the meshtags need to be split by ; for each resource (headers isn't working yet[10]-> ['tags'])
external_resources.each do |resource|
	tags = []
	tags = resource[10]
	#to prevent spliting a blank cell
	if(tags != nil)
        #may need to be a , or a ; bellow
		tags = tags.split(",")
		meshtags.push(tags)
	end
end

#puts meshtags
puts

# Now we will output the file in .csv as a check (taken out)
# puts 'now on to the file'
# File.open("Mesh_tags_from_resources.csv", "w") do |file|
#         meshtags.each do |resource_tags|
#         	file.write(resource_tags)
#         	file.write("\r\n")
#         end 
# end

#creates a list of unique mesh tags
 uniq_mesh_array = []
 meshtags.each do |line|
 	uniq_mesh_array = uniq_mesh_array + line
 end
 uniq_mesh_array = uniq_mesh_array.uniq

puts "unique Mesh Terms from external_resources saved @ Unique_Mesh_tags_from_resources.csv"
puts 'unique Mesh Terms:'
puts
puts uniq_mesh_array


#saves it to a file
  File.open("DELETE_ME_Unique_Mesh_tags_from_resources.csv", "w") do |file|
        uniq_mesh_array.each do |resource_tags|
        	file.write(resource_tags)
        	file.write("\r\n")
        end 
    end



puts
puts

#from Greg
old_mesh_array = []
  File.readlines("existing_tags.yml").sort.each do |line|
    # get the ID
    mesh_id = line[0,7]
    # get name
    name = line[/\".*?\"/][1..-1].chop
    # get list_boolean preference
    list_boolean = false
    if line.include? "list: true,"
    	list_boolean = true
    end
    # make an multidimensional array of the new values
    
    old_mesh_array << [ mesh_id, name, list_boolean ]
    # Throw out duplicate values based on ID    
    old_mesh_array = old_mesh_array.uniq { |e| e[0] }
  end
#checks the old array 
puts old_mesh_array [1][1]

puts 
puts
# takes the old mesh array and leaves only the names in a list and then 
# finds the terms already used
# the code excluded should do the same (from Greg), but i couldn't get it
#to work 
# new_mesh_array_terms = uniq_mesh_array.select {|new_item| 
# 			old_mesh_array.detect { |old_item|
# 				new_item[0] == old_item[0]
# 				} 
# 	}
# the above 
new_mesh_array_terms = []
old_mesh_list = []
old_mesh_array.each do |tag|
	old_mesh_list.push(tag[1])
end	
new_mesh_array_terms = uniq_mesh_array - old_mesh_list

puts
# checks the new mesh array
puts "new_mesh_array_terms:"
puts
puts new_mesh_array_terms

 File.open("DELETE_ME_new_mesh_array_terms.csv", "w") do |file|
        new_mesh_array_terms.each do |resource_tags|
            file.write(resource_tags)
            file.write("\r\n")
        end 
    end

puts
puts

# Sometimes a user may want to quit the program if they see an important tag that they want to add
# alternativly the tags may not be of much importance (i.e. Human) and the user may want to continue to add
# the resources using only tags that happen to already be of use on the site
puts "If you would like to quit the program and add some of the above MeSH tags to the trekk site type 'yes'. If instead you would like to continue to add the external_resources without the new mesh array terms type 'no'"
puts '> '
answer = gets.chomp.downcase
if answer == "yes"
    return
end


# this next section will take out Mesh Tags not in use by TREKK.ca from external resources
external_resources.each do |resource|
    tags = []
    tags = resource[10]
    #to prevent spliting a blank cell
    if(tags != nil)
        #may need to be a , or a ; bellow
        tags = tags.split(",")
        tags = tags - new_mesh_array_terms
    end
    resource[10]= tags
end

puts
puts "new external_resources file output @ external_resources_output.csv"

File.open("DELETE_ME_external_resources_output.csv", "w") do |file|
        external_resources.each do |resource|
            file.write(resource)
        end 
    end

puts 'done!'

























