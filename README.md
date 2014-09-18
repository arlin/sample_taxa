sample_taxa
===========

treeforall hackathon project: Given the request for a modestly sized tree for a large taxon T, support various useful ways to sample from taxon T, including (1) a random sample of species from T, (2) the species in T that have a genome in NCBI genomes, and (3) the top N species in T in terms of the number of occurrence records in iDigBio.  

## More info

see the google doc https://docs.google.com/document/d/1E3QIxEYUu4Q6A3Dc_zJUoxb0O0vEWX88_2ptYW1iMjg

## Targets 

1. choose N species randomly from T
2. choose those species from N that have property A, e.g., has NCBI genome
3. choose the top N species from T by relevance metric, e.g., counts in iDigBio

## data directory 

There is a README.md in the data directory

## perl directory 

See the README.md in the perl directory.  This contains scripts to obtain the induced subtree for any species in a named taxon that have genomes in NCBI. 

## python directory 

See the README.md in the python directory.  

## random_sample directory

This contains code to implement the random sub-sampling case.  