#!/usr/bin/perl -w 
#

=head1 NAME

tree_for_genomes_in_taxon.pl - get OpenTree phylogeny for species in named taxon with NCBI genome entry 

=head1 SYNOPSIS

    tree_for_genomes_in_taxon.pl --email EMAIL --taxon TAXON --file FILE

    --help, --?         print help message
    --fuzzy				use approximate matching (off by default)
    --open				invoke system to open file in tree viewer (see below)

Examples:

    tree_for_genomes_in_taxon.pl --email=arlin@umd.edu --taxon Rodentia --file FILE

=head1 DESCRIPTION

This is a wrapper for other scripts that invoke web services (from NCBI and OpenTree) to obtain a phylogeny for a set of species in a given taxon that have genomes in NCBI Genome. 

The fuzzy flag sets do_approximate_matching to true when names are matched using OpenTree's TNRS.  

The "open" flag invokes system( "open \$outfile" ) which will work on a Mac if you have set your Mac to open .nwk files with your installed tree viewer (ctrl-click on .nwk file, choose "get info", choose "open with" and select your viewer, click "change all" to apply to all files with the same extension). 

If no output file name is given, the results go in induced_subtree.nwk .

=head1 KNOWN ISSUES

=head1 AUTHOR

Arlin Stoltzfus (arlin@umd.edu)

=cut

use strict; 
use Getopt::Long; 
use XML::Simple; 
use Data::Dumper; 
use Pod::Usage; 

# set the paths to each of the scripts we need
#
my $search_script = "./esearch_genomes_by_tax.pl"; 
my $link_script = "./taxids_from_genome_ids.pl"; 
my $names_script = "./sci_names_from_taxids.pl"; 
my $ot_match_script = "./ot_match_names.pl"; 
my $ot_subtree_script = "./ot_induced_subtree.pl"; 

# process command-line arguments 
#
my ( $help ); 
my $email = "arlin\@umd.edu"; 
my $taxon = "Rodentia"; 
my $outfile = "induced_subtree.nwk"; 
my $fuzzy = 0;
my $open = 0; 

GetOptions(
    "email=s" => \$email,   
    "taxon=s" => \$taxon, 
    "fuzzy!" => \$fuzzy, 
    "open!" => \$open, 
    "file=s" => \$outfile, 
    "help|?" => \$help
    ) or pod2usage( "Invalid command-line options." );
pod2usage() if defined( $help ); 

### invoke the scripts to get a tree 

my $command = "$search_script --email=$email --taxon $taxon";
my $g_ids_string = `$command`; 
chomp($g_ids_string); 

$command = "$link_script --email=$email --uids=\"$g_ids_string\"";
my $taxids_string = `$command`;
chomp($taxids_string); 

$command = "$names_script --email=$email --uids=\"$taxids_string\"";
my $names_string = `$command`;
chomp($names_string); 

$command = "$ot_match_script --names=\'$names_string\'";
$command .= ( $fuzzy ? " --fuzzy" : "" ); 
my $ottIds_string = `$command`;
chomp($ottIds_string); 

# ot_induced_subtree.pl --ids '633213,796660,292504'
$command = "$ot_subtree_script --ids=\'$ottIds_string\'";
my $result = `$command`;

# debug 
# printf("$command\n$result\n"); 

printf("$result"); 

open(my $fh, ">", $outfile ) or die "cannot open > $outfile: $!";
printf( $fh $result ); 

system( "open $outfile" ) if $open;  

# exit; 


# and exit
exit; 

