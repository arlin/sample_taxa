Python scripts for downsampling
===============================

Python scripts that use different approaches to select a subset of taxa for querying the Open Tree of Life

##Scripts for querying iDigBio using APIs
Python scripts that begin with "getIdigBio" will retreive the the species names and number of occurrences for the top 100 most common species within the taxon that is queried. The getIdigbioMammals.py will retrieve the top 100 mammal records. Data will be output as a csv file with two columns, species and #occurrences. The scripts filter so that only records that have a binomial scientific name will be written to the file. 

The output files can then be used to query Open Tree of Life for ott IDs and then retrieve an induced tree. This can also be done using the Workflow to get an induced tree from a matrix workflow in Arbor <https://arbor.kitware.com/#>.

