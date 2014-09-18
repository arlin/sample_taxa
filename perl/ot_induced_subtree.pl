#!/usr/bin/perl -w 
#

=head1 NAME

ot_induced_subtree.pl - get ottIds for named species using OpenTree web services

=head1 SYNOPSIS

    ot_induced_subtree.pl --ids "<id1>[,<id2>]*" --file FILE

    --help, --?         print help message

Where I<FILE> is an optional file name to dump output for troubleshooting. 

Examples:

    ot_induced_subtree.pl --ids '633213,796660,292504'  

=head1 DESCRIPTION

This returns the induced subtree for the identified taxa. 

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

my ( $ids, $help ); 
my $outfile = "induced_subtree_result.json";
GetOptions(
    "ids=s" => \$ids, 
    "file=s" => \$outfile, 
    "help|?" => \$help
    ) or pod2usage( "Invalid command-line options." );
pod2usage() if defined( $help ); 

my $script = $0; 
$script =~ s#^.*/##; 

# construct the command 
#
my $base_url = "http://devapi.opentreeoflife.org/v2/tree_of_life/induced_subtree"; 
my $header = "Content-Type:application/json"; 
# json: {"ott_ids":[732037, 764828, 238412,...]}
my $body = sprintf( "{\"ott_ids\":[%s]}", $ids ); 
my $command = sprintf( "curl -X POST $base_url -H \"$header\" -d \'$body\'" ); 

# debug 
# printf("$command\n"); 
# exit; 

# execute the command 
#
my $json = `$command`; 
my $result = decode_json($json);
my $newick = $result->{ 'subtree' }; 

# let's put this in a log file for debugging purposes 
open(my $fh, ">", $outfile ) or die "cannot open > $outfile: $!";
printf( $fh $json ); 
printf( STDERR "The return from executing the command ($command) is in $outfile\n" ); 

# output and exit
printf( "%s\n", $newick ); 
exit; 
