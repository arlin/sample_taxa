#!/usr/bin/perl -w 
#

=head1 NAME

sci_names_from_taxids.pl - Perl wrapper to get tqxids from a list of genome ids

=head1 SYNOPSIS

    sci_names_from_taxids.pl --email EMAIL --taxids "<uid>[,<uid]+" --file FILE

    --help, --?         print help message

Where I<FILE> is an optional file name to dump output for troubleshooting. 

Examples:

    sci_names_from_taxids.pl --email=arlin@umd.edu --uids="23993,16985,14031,10802" 

=head1 DESCRIPTION

This is for a specific purpose-- find the species names associated with taxids. 

If no output file is specified, results go into esummary_result.xml.  

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
my $email = "arlin\@umd.edu"; 

my ( $taxids, $help ); 
my $outfile = "esummary_result.xml";
GetOptions(
    "email=s" => \$email,   
    "uids=s" => \$taxids, 
    "file=s" => \$outfile, 
    "help|?" => \$help
    ) or pod2usage( "Invalid command-line options." );
pod2usage() if defined( $help ); 

my $script = $0; 
$script =~ s#^.*/##; 

# construct the URL 
#
my $base_url = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esummary.fcgi"; 
my $query_url = sprintf( "%s?retmax=1000&tool=%s&version=2.0&db=taxonomy&email=%s&id=%s", $base_url, $script, $email, $taxids ); 

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

# DocumentSummarySet->DocumentSummary gives array, traverse this to get ScientificName
my @docs = @{ $output->{ DocumentSummarySet }->{ DocumentSummary } }; 
my @names; 
for my $doc ( @docs ) { 
	push( @names, $doc->{ ScientificName } ); 
}
printf("\"%s\"\n", join( '","', @names )); 

# and exit
exit; 
