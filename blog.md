draft OpenTree blog on the taxon sampling group
===============================================

# Hackathon report: trees that sample from a given taxon  

## The idea of trees that sample from a given taxon 

Subtree extraction (getting the induced subtree) is clearly useful.  Many users may have a character matrix for a given set of species, and the induced_tree method from OT allows them to get a tree for their set of species.  

In other cases, the user may be focused on a taxon T.  For instance, the typical user who wants a tree of mammals does not really want a full tree with 4500 species, but some subset, e.g., a random subset of 100 species, or the 94 species with known genomes in NCBI, or one species for each of ~150 mammal families.  

The various ways to sample a taxon fall into 3 categories.  First, sampling T by <b>sub-setting</b> is simply getting all the species with a desired attribute A, e.g., 
* has genome in NCBI genomes (see this downloaded table)
* has species page in EOL 
* has image in phylopic.org (organisms silhouettes for adorning trees)
* has iDigBio occurrence records in my region 

Second, we might use the term <b>down-sampling</b> to refer to methods that reduce the complexity of the tree without using any outside information, e.g.,  
* get a random sample of N species from taxon T
* down-sample nodes according to subnode density 
* choose N species to maximize phylogenetic diversity

Finally, we can imagine a kind of <b>relevance sampling</b>, where we apply some measure of importance or relevance R, and use that to choose (from T) the top N species
* by number of google hits
* by number of occurrence records in iDigBio
* by number of PubMed hits

## The sampling group at the first OpenTree hackathon 

< generic description of hackathon event taking place Sept 15 to 19 at U. Michigan, Ann Arbor.> 

The "taxon sampling" group took on the challenge of demonstrating various methods of getting a tree using various languages and tools, followed by using OpenTree tools to obtain a tree for the sample.  They focused on one case of sub-setting (get species in T with entries in NCBI Genomes), one case of down-sampling (get a random sample of N species from T), and one case of relevance sampling (get the N species in T with the most occurrence records in iDigBio). 

## Down-sampling 

< random sampling: Jonathan and Dilrini > 

## Sub-setting 

< arbor: Andrea > 
< perl: Arlin > 
< Open Refine: Nicky > 

## Relevance sampling 

< PhyloJive: Andrea > 

