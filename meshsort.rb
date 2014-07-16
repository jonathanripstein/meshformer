#Meshsort script

#!/usr/bin/env ruby

old_mesh_array = []
new_mesh_array = []

File.open("en.yml", "w") do |file|


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



  File.readlines("new_tags.txt").sort.each do |line|
    # get the ID
    mesh_id = line[0,7]
    # get name
    name = line[/\".*?\"/][1..-1].chop
    # list_boolean preference assumed to be false
    list_boolean = false
    # make an multidimensional array of the new values
    new_mesh_array << [ mesh_id, name, list_boolean ]
    # throw out duplicate values based on ID
    new_mesh_array = new_mesh_array.uniq { |e| e[0] }    
  end

  	# purge vales in new array that are already present in old array
	new_mesh_array_removable = new_mesh_array.select {|new_item|  
			old_mesh_array.detect { |old_item|
				new_item[0] == old_item[0]
				} 
	}
	new_mesh_array = new_mesh_array - new_mesh_array_removable

	# combine the old with the new
  	combined_mesh_array = old_mesh_array + new_mesh_array

  	# sort the resulting multidimensional array based on name not ID
  	# add the "@"" so that the variable is available outside of this block
  	@combined_mesh_array = combined_mesh_array.sort_by { |e| e[1] }


  	@combined_mesh_array.each {|subarray|
		file.write(subarray[0])
		file.write(": ")
		file.write('"') 
		file.write(subarray[1])
		file.write('"')   	
		file.write("\n")   		
  	}

end

File.open("tags.yml", "w") do |file|

	# seek to replicate: D016512: { list: false, note: "Ankle Injury" }

  	@combined_mesh_array.each {|subarray|
		file.write(subarray[0])
		file.write(': { list: ') 
		file.write(subarray[2])
		file.write(', note: "') 
		file.write(subarray[1])
		file.write('" }')   	
		file.write("\n")   		
  	}

end

########################################################################
# JUNK CODE
########################################################################
# Place snippets here that you don't think are needed 
# but that you might want to reactivate.
########################
# File.open('existing_tags.yml', 'w') do |out_file|
########################
# file.write(mesh_id)
# file.write("---")
# file.write(name) 
# file.write("---")
# file.write(list_boolean)    	
# file.write("\n")  
########################