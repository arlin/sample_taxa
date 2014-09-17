# -*- coding: utf-8 -*-
# <nbformat>3.0</nbformat>

# <headingcell level=1>

# # Tree-for-all hackathon 16 Sept 2014

# <headingcell level=2>

# # git clone git@github.com:arlin/sample_taxa.git 
# # git clone git@github.com:OpenTreeOfLife/opentree-interfaces.git
# # sudo pip install BioPython
# # sudo pip install CStringIO 
# # sudo pip install matplotlib
# # sudo pip install numpy
# # cd sample_taxa

# <codecell>

import sys
import argparse
import re
from cStringIO import StringIO
from Bio import Phylo
import opentreelib
import matplotlib
import pylab


# use argparse to parse command line arguments, etc.
parser = argparse.ArgumentParser(description='Generate an induced subtree by random sampling')
parser.add_argument('-t', type=str, dest = 'taxon',
                   help='Taxon to sample from')
parser.add_argument('-m', dest='sampling_mode',
                   help='Sampling mode (Default: random)')
parser.add_argument('-n', dest='ntaxa', type=int,
                   help='No. of taxa in induced subtree')
parser.add_argument('-d', dest='draw', action='store_true',
                   help='Draw tree')
parser.add_argument('-o', dest='out',
                   help='Output file name')
parser.set_defaults(sampling_mode = "random", draw=False)

#args = parser.parse_args(['-t', 'Mammalia', '-m', 'random', '-n', '30','-d', '-o', 'my_induced_subtree_example.nwk'])
args = parser.parse_args()

# <markdowncell>

# Given a taxon name, find the OTT id of that taxon.
# Careful about unicode - arg should be unicode.
# TO BE DONE: Make this robust to unknown names and to homonyms.

# <codecell>

# Methods

# Given a taxon name retrieve the OTTid

def unique_ott_id(name):
    tnrs_result = opentreelib.tnrs_match_names([name])
    ottid = tnrs_result['results'][0]['matches'][0]['ot:ottId']
    return ottid

# Given an OTT id, return names and ids of species at or under that
# taxon in the taxonomy.

def all_species(OTTid):
    treeresult = opentreelib.tree_of_life_subtree(ott_id = OTTid)
    # Look for names of the form Genus epithet
    tree = Phylo.read(StringIO(treeresult['newick']), 'newick')

    matchSpecies = re.compile('(^[A-Z][a-z]*)_([a-z]+)_ott([0-9]+)$')
    species = {}

    # Work in progress
    def processNode(node):
        if isinstance(node.name, str):
            m = matchSpecies.search(node.name)
            if m != None:
                species[m.group(1) + ' ' + m.group(2)] = int(m.group(3))
        else:
            print "Node name is not a string", node.name

    for node in tree.get_terminals():
        processNode(node)
    for node in tree.get_nonterminals():
        processNode(node)

    return species


# Given a list of OTTids, get a random sample
def get_random_sample(OTTids_list, length):
    x = np.asarray(OTTids_list.values()) # convert to numpy array
    subset = np.random.choice(x,size = length, replace =False)
    return subset.tolist()

# Given a list of OTTids, retrieve the induced subtree
def subtree_species(species_list):
    subtreeresult = opentreelib.tree_of_life_induced_subtree(ott_ids = species_list)
    subtree = Phylo.read(StringIO(subtreeresult['subtree']), 'newick')
    return subtree

# <codecell>

# parameters
taxon_name = args.taxon
mode = args.sampling_mode
num = args.ntaxa
outfile = args.out

# <codecell>

my_OTT_id = unique_ott_id(taxon_name)
my_species = all_species(my_OTT_id)

# <codecell>

if mode == "random":
    my_subset_species = get_random_sample(my_species,num)
    
my_induced_subtree = subtree_species(my_subset_species)

# <codecell>

# Write to file
Phylo.write(my_induced_subtree,outfile,'newick')

# Draw induced subtree - Work in progress. Pipe to a different plotting program.
if args.draw:
    Phylo.draw(my_induced_subtree)
    #pylab.show()
    #pylab.savefig("fig.png")
    

# <codecell>


