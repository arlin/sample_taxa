#!/usr/bin/perl -w 
#

=head1 NAME

esearch_genomes_by_tax.pl - Perl wrapper to get IDs for genomes with taxonomy restriction

=head1 SYNOPSIS

    esearch_genomes_by_tax.pl --email EMAIL --taxon TAXON --file FILE

    --help, --?         print help message

Where I<FILE> is a file name. Stdout gets a comma-separated list of IDs (and there are some message from wget and this script on stderr).  

Examples:

    esearch_genomes_by_tax.pl --email=arlin@umd.edu --taxon "Rodentia" 

=head1 DESCRIPTION

This is for a specific purpose-- identify the genomes available for a named taxonomic group.  This is implemented as a thin wrapper around NCBI's esearch utility. 

If no output file is specified, results go into esearch_result.xml.  

This script only retrieves IDs.  To go further requires following this up with efetch or esummary. 

=head1 KNOWN ISSUES

This uses wget (better to use LWP or BioPerl). 

Currently the output is confusing, due to messages from wget.  

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
my ( $email, $taxon, $help ); 
my $outfile = "esearch_result.xml";
GetOptions(
    "email=s" => \$email,   
    "taxon=s" => \$taxon, 
    "file=s" => \$outfile, 
    "help|?" => \$help
    ) or pod2usage( "Invalid command-line options." );
pod2usage() if defined( $help ); 

my $script = $0; 
$script =~ s#^.*/##; 

# construct the URL
#
my $base_url = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi"; 
my $query_url = sprintf( "%s?tool=%s&email=%s&db=genome&retmax=1000&term=%s[organism]", $base_url, $script, $email, $taxon ); 

# debug 
# printf("$query_url \n"); 
# exit; 

# execute the query 
#
`wget -O $outfile "$query_url"`;

printf STDERR "The results of the query ($query_url) are in $outfile.\n";

# now lets see what we got
my $xml = new XML::Simple;
my $output = $xml->XMLin("$outfile");
# print Dumper($output);
my $uids = join( ",", @{ $output->{ IdList }->{ Id } }); 
printf("$uids\n"); 

# and exit
#
exit; 
