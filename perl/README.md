perl code for sample_taxa
===========

This directory contains Perl scripts to execute the case of getting a tree for species in a named taxon that have genomes in the genomes division of NCBI.  The master script is invoked like this: 

	tree_for_genomes_in_taxon.pl --taxon "Rodentia" 
	
Other nice examples are "Reptilia", "Carnivora", "Felidae", "Thermoprotei".  Not everything works this well (Streptophyta, Basidiomycota). 

The master script invokes 5 other scripts.  The first 3 subsidiary scripts use eutils (NCBI web services) to find genome entries matching a taxon, link those to NCBIs taxonomy database, and get species names.  The remaining subsidiary scripts use OpenTree web services to find ott identifiers for the named species, and to get the induced subtree from the list of ott identifiers. 

# Known issues

Bug reports are welcome-- check the github issues before starting a new one.  See the dependencies below.  These are very brittle.  There is no error-checking, so a failure at any step is going to break this.  We have found many queries that do not succeed when they get to the OpenTree services, for unknown reasons.    

# Scripts 

* tree_for_genomes_in_taxon.pl - master script that goes from named taxon to Newick tree
* ot_induced_subtree.pl - takes in OT ids, provides induced tree
* ot_match_names.pl - takes in taxon names, returns OT ids 
* sci_names_from_taxids.pl - takes in NCBI taxids, returns scientific names
* taxids_from_genome_ids.pl - takes in NCBI genome ids, returns taxids
* esearch_genomes_by_tax.pl - takes in taxon name, returns genome ids

# Dependencies 

Libraries 
* Getopt::Long - script interfaces
* Pod::Usage - script interfaces
* XML::Simple - to parse NCBI eutils outputs
* JSON - to parse OpenTree services outputs
* Data::Dumper - for debugging only 

Tools 
* wget 
* curl 


