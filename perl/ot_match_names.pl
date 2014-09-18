#!/usr/bin/perl -w 
#

=head1 NAME

ot_match_names.pl - get ottIds for named species using OpenTree web services

=head1 SYNOPSIS

    ot_match_names.pl --names "<name1>[ ,<name2>]*" --file FILE

    --help, --?         print help message

Where I<FILE> is an optional file name to dump output for troubleshooting. 

Examples:

    ot_match_names.pl --names '"Panthera tigris","Sorex araneus","Erinaceus europaeus"'  

=head1 DESCRIPTION

This returns a compact list of ottId values ("val1,val2,val3"). 

=head1 KNOWN ISSUES

=head1 AUTHOR

Arlin Stoltzfus (arlin@umd.edu)

=cut

use strict; 
use Getopt::Long; 
use JSON qw( decode_json );
use Data::Dumper; 
use Pod::Usage; 

# process command-line arguments 
#
my $email = "arlin\@umd.edu"; 

my ( $names, $help ); 
my $outfile = "match_result.json";
GetOptions(
    "email=s" => \$email,   
    "names=s" => \$names, 
    "file=s" => \$outfile, 
    "help|?" => \$help
    ) or pod2usage( "Invalid command-line options." );
pod2usage() if defined( $help ); 

my $script = $0; 
$script =~ s#^.*/##; 

# construct the URL 
#
my $base_url = "http://devapi.opentreeoflife.org/v2/tnrs/match_names"; 
my $header = "Content-Type:application/json"; 
# json: {"names":["Aster","Symphyotrichum","Erigeron","Barnadesia"]}
my $body = sprintf( "{\"names\":[%s]}", $names ); 
my $command = sprintf( "curl -X POST $base_url -H \"$header\" -d \'$body\'" ); 

# debug 
# printf("$command\n"); 
# exit; 

# execute the command 
#
my $json = `$command`; 
my $result = decode_json($json);
my @ottIds; 

# let's put this in a log file for debugging purposes 
open(my $fh, ">", $outfile ) or die "cannot open > $outfile: $!";
printf( $fh $json ); 
printf( STDERR "The return from executing the command ($command) is in $outfile\n" ); 

# took me a while to figure out how to parse this json due to all the structure 
#
my $r_ref = $result->{ 'results' }; 
foreach my $h_matches (@{ $r_ref }) { 
#	print $h_matches->{ 'id' } . "\n"; 
	foreach my $match (@{ $h_matches->{ 'matches' } }) { 
		printf( STDERR "%s,%s\n",  $match->{ 'search_string' }, $match->{ 'ot:ottId' } ); 	
		push(@ottIds, $match->{ 'ot:ottId' } ); 
	}
}
printf( "%s\n", join( ",", @ottIds ) ); 

# and exit
exit; 
