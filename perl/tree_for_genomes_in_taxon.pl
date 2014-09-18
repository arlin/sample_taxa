#!/usr/bin/perl -w 
#

=head1 NAME

tree_for_genomes_in_taxon.pl - get OpenTree phylogeny for species in named taxon with NCBI genome entry 

=head1 SYNOPSIS

    tree_for_genomes_in_taxon.pl --email EMAIL --taxon TAXON --file FILE

    --help, --?         print help message

Where I<FILE> is an optional file name to dump output for troubleshooting. 

Examples:

    tree_for_genomes_in_taxon.pl --email=arlin@umd.edu --taxon Rodentia 

=head1 DESCRIPTION

This is a wrapper for other scripts that invoke web services (from NCBI and OpenTree) to obtain a phylogeny for a set of species in a given taxon that have genomes in NCBI Genome. 

If no output file is specified, results go into esummary_result.xml.  

=head1 KNOWN ISSUES

=head1 AUTHOR

Arlin Stoltzfus (arlin@umd.edu)

=cut

use strict; 
use Getopt::Long; 
use XML::Simple; 
use Data::Dumper; 
use Pod::Usage; 

# process command-line arguments 
#
my $email = "arlin\@umd.edu"; 
my $taxon = "Rodentia"; 

my ( $help ); 
my $outfile = "induced_subtree.nwk";

GetOptions(
    "email=s" => \$email,   
    "taxon=s" => \$taxon, 
    "file=s" => \$outfile, 
    "help|?" => \$help
    ) or pod2usage( "Invalid command-line options." );
pod2usage() if defined( $help ); 

my $search_script = "./esearch_genomes_by_tax.pl"; 
my $link_script = "./taxids_from_genome_ids.pl"; 
my $names_script = "./sci_names_from_taxids.pl"; 
my $ot_match_script = "./ot_match_names.pl"; 
my $ot_subtree_script = "./ot_induced_subtree.pl"; 

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

system( "open $outfile" ); 

# exit; 


# and exit
exit; 

