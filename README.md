# Mesh Formater

### Purpose to take new mesh tags and add them with alphabetical sorting to a list of old mesh tags 

---

## meshsort.rb

Runs the parsing script that requires 

##### new_tags.txt

##### existing_tags.yml 

to generate the output 

##### resulting_en.yml

##### resulting_tags.yml

---

Rules:

##### Detect and eliminate duplicate MESH ID's always keeping the old ones.
##### Wrap terms in double quotations so they tolerate internal symbols in their string values


## Example Input

---

## new_tags.txt

D004827, "Epilepsy"

D004844, "Epistaxis"

D005385, "Finger"

D005334, "Fever"

---

## existing_tags.yml

D050723: { list: false, note: "Fractures" }

D005547: { list: false, note: "Foreign Bodies" }

D005756: { list: false, note: "Gastritis" }

D005759: { list: true, note: "Gastroenteritis" }

---

## Example Output

#### Combine the above .txt and .yml to yield resulting_tags.yml AND separate resulting_en.yml file output that is sorted and formatted and ready to drop into a site.yml and en.yml file's respectively.



## resulting_tags.yml

D004827: { list: false, note: "Epilepsy" }

D004844: { list: false, note: "Epistaxis" }

D005385: { list: false, note: "Finger" }

D005334: { list: false, note: "Fever" }

D050723: { list: false, note: "Fractures" }

D005547: { list: false, note: "Foreign Bodies" }

D005756: { list: false, note: "Gastritis" }

D005759: { list: true, note: "Gastroenteritis" }


---

## resulting_en.yml

D004827: Epilepsy

D004844: Epistaxis

D005385: Finger

D005334: Fever

D050723: Fractures

D005547: Foreign Bodies

D005756: Gastritis

D005759: Gastroenteritis


---

There will be more formatting to come but this will get us started

---

## split_lines.rb 

runs a demo app to get you started












