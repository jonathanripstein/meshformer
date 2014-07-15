# split lines

#!/usr/bin/env ruby

# File.open('output.txt', 'w') do |out_file|
#   File.open('mesh_input.txt', 'r').each do |line|
#     out_file.print line.sub('foo', 'bar')
#   end
# end

File.open('output.txt', 'w') do |out_file|
  counter = 0
  10.times do |x|
	  result = File.readlines('mesh_input.txt')[counter]
	  out_file.print result
	  counter += 2
  end
end