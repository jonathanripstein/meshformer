# MeSHsort script
# Greg Van de Mosselaer
# July 16, 2014

#!/usr/bin/env ruby

# This script performs the following actions
#############################################
# Make multidimensional array of old list
# --- Throw out an duplicates from old list that were not previously detected
# Make multidimensional array of new list
# --- Throw out any internal duplicates from new list
# --- Throw out any external duplicates from new list (If MeSH ID already present on old list)
# Combine both multidimensional arrays into one
# Sort the resulting multidimensional array by name
# Generate file en.yml based on resulting multidimensional array
# Generate file tags.yml based on resulting multidimensional array

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


# Depenencies
#############################################
# Presence of existing_tags.yml with each line exactly 
# formatted like > D016512: { list: false, note: "Ankle Injury" }
# Presence of new_tags.txt with each line exactly 
# formatted like >  D000038, "Abscess" 
# The matching of the above punctuation is important as the script
# uses the punctuation to extract the correct values from each line.
# Inconsistent punctuation will generate unusable output.

# Use
#############################################
# Load existing_tags.yml with your current tags.yml from the kernel 
# Load new_tags.txt with yout proposed additions
# From the terminal prompt run $ruby meshsort.rb then inspect the contents
# of tags.yml and en.yml using sumbime text or other text app
# If you are the programmer cut and paste these into tags.yml and en.yml 
# on the kernel and fire up the test server to test.
# To run script again remember to clear the contents 
# of tags.yml and en.yml
#############################################

