#hi This program requires the same external resource csv file as before. It however goes and finds the PMID and coresponding title 
#by searching pubmed using the REF ID collumn. its output contains these new peices of info 
# not all the PMIDS returned corespond to the correct article (must be cleaned) and often there are multiple PMID's for different versions
#output is external resources with PMIDS.csv


require 'open-uri'
require 'nokogiri'
require 'csv'
puts 'hi user file name of the external_resources in .csv'
puts '> '
external_resourcesfile = gets.chomp



#open the file
external_resources = CSV.read(external_resourcesfile, headers:true)
external_resources.each do |resource|
	result = open("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term="+ resource[0]).read
	puts puts

	doc = Nokogiri::XML(result)

	#/thing = doc.at_xpath('//IdList')
	#puts "Id = " + thing.at_xpath('Id').content/

	id = doc.xpath('//Id')
	id.each do |inID|
		puts inID.content
	
		efectch = open("http://eutils.ncbi.nlm.nih.gov/entrez/eutils/efetch.fcgi?db=pubmed&id=#{inID.content}&rettype=docsum&retmode=txt").read
		text = efectch.split(".")
		puts text[1]		
		resource.push(inID.content)
		resource.push(text[1])
	end
	



end

File.open("external_resources_with_PMIDS.csv", "w") do |file|
        file.write(external_resources)
    end


