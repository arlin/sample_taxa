#!/usr/bin/perl -w 
#

=head1 NAME

taxids_from_genome_ids.pl - Perl wrapper to get tqxids from a list of genome ids

=head1 SYNOPSIS

    taxids_from_genome_ids.pl --email EMAIL --uids "<uid>[,<uid]+" --file FILE

    --help, --?         print help message

Where I<FILE> is an optional file name to dump output for troubleshooting. 

Examples:

    taxids_from_genome_ids.pl --email=arlin@umd.edu --uids="23993,16985,14031,10802" 

=head1 DESCRIPTION

This is for a specific purpose-- find the taxids associated with genome ids, so we can get species names. 

If no output file is specified, results go into elink_result.xml.  

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

my ( $uids, $help ); 
my $outfile = "elink_result.xml";
GetOptions(
    "email=s" => \$email,   
    "uids=s" => \$uids, 
    "file=s" => \$outfile, 
    "help|?" => \$help
    ) or pod2usage( "Invalid command-line options." );
pod2usage() if defined( $help ); 

my $script = $0; 
$script =~ s#^.*/##; 

# remove any spaces from user's input list 
$uids =~ s/\s+//g; 

# construct the URL 
#
my $base_url = "http://eutils.ncbi.nlm.nih.gov/entrez/eutils/elink.fcgi"; 
my $query_url = sprintf( "%s?retmax=1000&tool=%s&email=%s&dbfrom=genome&db=taxonomy&id=%s", $base_url, $script, $email, $uids ); 

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

# we need to dig in to eLinkResult->LinkSet->LinkSetDb->Link->Id

my @links = @{ $output->{ LinkSet }->{ LinkSetDb }->{ Link } }; 
my @taxids; 
for my $link ( @links ) { 
	push( @taxids, $link->{ Id } ); 
}
printf("%s\n", join( ",", @taxids ) ); 

# and exit
#
exit; 
