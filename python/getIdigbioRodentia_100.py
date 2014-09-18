import json
import urllib2
import requests
import csv

url = "http://search.idigbio.org/idigbio/records/_search"
data = {
    "query": {
	"query_string" : {
			"default_field" : "order",
       		"query" : "rodentia"
    	}
    },
    "aggregations": {
        "my_agg": {
            "terms": {
               "field": "scientificname",
               "size": 100
            }
        }
    }
}

headers = {'Content-type': 'application/json', 'Accept': 'text/plain'}
r = requests.post(url, data=json.dumps(data), headers=headers)
data = json.loads(r.text)

outCsvFile = open("idigbioRodents_100.csv", 'wb')
outCsvWriter = csv.writer(outCsvFile, dialect='excel')
outCsvWriter.writerow(["species", "#Occurrences"])
uniqKeys = {}
#print data["aggregations"]["my_agg"]["buckets"]
for item in  data["aggregations"]["my_agg"]["buckets"]:
    parts = item["key"].split()
    if len(parts) == 2:
        if not "sp" in parts[0] and not "sp" in parts[1]:
            if not ("?" in parts[0] or "?" in parts[1]):
                if not ("." in parts[0] or "." in parts[1]):
                    if item["key"] in uniqKeys:
                        print "Warning: already counted", item["key"], "parts:", parts
                    uniqKeys[item["key"]] = ""
                    outCsvWriter.writerow([item["key"], item["doc_count"]])
