import csv
import opentreelib
import argparse
import sys

argparser = argparse.ArgumentParser(description='Insert a column of OTT ids into a csv file')
argparser.add_argument('-i', dest='inf', help='CSV input file name')
argparser.add_argument('-o', dest='outf', help='CSV output file name')
args = argparser.parse_args()

rows = []

header_row = None

with open(args.inf, 'rb') as csvfile:
    reader = csv.reader(csvfile)
    header_row = reader.next()
    print 'Header', header_row
    for row in reader:
        rows.append(row)

name_column = 0

# Get list of all ids
ids = []
for row in rows:
    ids.append(row[name_column])

lumps = {}

tnrs_return = opentreelib.tnrs_match_names(ids, do_approximate_matching=False)
import pprint
pprint.PrettyPrinter().pprint(tnrs_return)
for lump in tnrs_return['results']:
    lumps[lump['id']] = lump['matches']

# Add the OTT id as a new column at the right side of the table
for row in rows:
    name = row[name_column]
    if name in lumps:
        matches = lumps[name]
        if len(matches) == 1:
            match = matches[0]
            if 'ot:ottId' in match:
                m = match['ot:ottId']
            else:
                m = '?'
        else:
            m = '???'
    else:
        m = '??'
    row.append(m)

with open(args.outf, 'wb') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(header_row + ['ott_id'])
    for line in rows:
        writer.writerow(line)
