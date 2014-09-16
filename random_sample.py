# Hackathon 16 Sept 2014

# git clone git@github.com:arlin/sample_taxa.git
# git clone git@github.com:OpenTreeOfLife/opentree-interfaces.git
# sudo pip install BioPython
# sudo pip install CStringIO
# cd sample_taxa

import opentreelib
import re
from Bio import Phylo
from cStringIO import StringIO

# optparse

# Given a taxon name, find the OTT id of that taxon.
# Careful about unicode - arg should be unicode.
# TO BE DONE: Make this robust to unknown names and to homonyms.
def uniqueOTTid(name):
    tnrs_result = opentreelib.tnrs_match_names([name])
    ottid = tnrs_result['results'][0]['matches'][0]['ot:ottId']
    return ottid

# Given an OTT id, return names and ids of species at or under that
# taxon in the taxonomy.

def allSpecies(OTTid):
    treeresult = opentreelib.tree_of_life_subtree(ott_id = OTTid)
    # Look for names of the form Genus epithet
    tree = Phylo.read(StringIO(treeresult['newick']), 'newick')

    matchSpecies = re.compile('(^[A-Z][a-z]*)_([a-z]+)_ott([0-9]+)$')
    species = {}

    # Work in progress
    def processNode(node):
        m = matchSpecies.search(node.name)
        if m != None:
            species[m.group(1) + ' ' + m.group(2)] = int(m.group(3))

    for node in tree.get_terminals():
        processNode(node)
    for node in tree.get_nonterminals():
        processNode(node)

    return species
