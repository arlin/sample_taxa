data for sample_taxa
===========

Data subdirectory for the treeforall hackathon project (given the request for a modestly sized tree for a large taxon T, support various useful ways to sample from taxon T)

# Files 

## mammal_genomes.csv 

contents: data on mammalian genomes in NCBI Genomes. The first row is a header line (species,Kingdom,Group,SubGroup,Size (Mb),Chr,Organelles,Plasmids,Assemblies).  It's important for the Arbor workflow that the first column is called "species" 

format: csv.  

provenance: obtained interactively from the NCBI web site.   

## idigbioMammalsBionomialsOnly.csv 

contents: download of the mammals in iDigBio ranked by number of records. Includes some mistakes (e.g. Equus sp.)

format: csv

provenance: obtained via querying the iDigBio API (Andrea).  Processed to remove non-binomials.

## idigbioMammalsBinomialsOnlyNosp_50.csv

contents: download of the mammals in iDigBio ranked by number of records, only includes species with the 50 highest occurrences.

format: csv

provenance: obtained via querying the iDigBio API (Andrea). Processed to remove non-binomials.

## another file 

contents: 

format: 

provenance: 

