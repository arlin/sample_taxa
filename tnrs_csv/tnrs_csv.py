# Tree-for-all hackathon, 18 September 2014
#
# This is a simple demonstration script with a general function: 
#
#  input - a CSV file one of whose columns contains taxon names
#  output - the same CSV file, with an additional column giving OTT
#    ids for those names
#
# This uses the 'opentreelib' library (originally defined in the
# OpenTreeOfLife/opentree-interfaces repo in github, but it may have moved in
# another hackathon repo) to talk to the Open Tree API.  So to use
# this script, you'll need to get opentreelib.py.  Tested against commit
# be2602a1, i.e.
# https://raw.githubusercontent.com/OpenTreeOfLife/opentree-interfaces/be2602a1284cfdf862b0bf678e436f730a048c68/python/opentreelib.py
#
# Example: python tnrs_csv.py -i ../data/idigbio_cleaned.csv -o out.csv
#
# Author: Jonathan A. Rees

import csv
import opentreelib
import argparse
import sys

argparser = argparse.ArgumentParser(description='Insert a column of OTT ids into a csv file')
argparser.add_argument('-i', dest='inf', help='CSV input file name')
argparser.add_argument('-o', dest='outf', help='CSV output file name')
args = argparser.parse_args()

# Read the CSV file.
# Assumes that there is a header row; TBD: as command line argument
# implement the case where there is no header row.

header_row = None
rows = []

with open(args.inf, 'rb') as csvfile:
    reader = csv.reader(csvfile)
    header_row = reader.next()
    for row in reader:
        rows.append(row)

# Choose the column that contains the names.  For now assume this is
# column 0; but the column really ought to be chosen by a command line
# argument, either by position or by column name (in header).

name_column = 0

# Extract just the taxon names from the table, as a vector, one entry per row.

ids = []
for row in rows:
    ids.append(row[name_column])

# Invoke the Open Tree TNRS service.
# TBD: consider doing fuzzy matches as well (with a high threshold).  Not
# clear what the user should do for names that don't uniquely resolve.

tnrs_return = opentreelib.tnrs_match_names(ids, do_approximate_matching=False)
# import pprint
# pprint.PrettyPrinter().pprint(tnrs_return)

# Process the wad of stuff that the TNRS returned.  First, index the
# results by taxon name.

name_to_matches = {}
for lump in tnrs_return['results']:
    name_to_matches[lump['id']] = lump['matches']

# Now add the OTT id as a new column at the right side of the table.

for row in rows:
    name = row[name_column]
    if name in name_to_matches:
        matches = name_to_matches[name]
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

# Write the new CSV out to a file.

with open(args.outf, 'wb') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(header_row + ['ott_id'])
    for line in rows:
        writer.writerow(line)
