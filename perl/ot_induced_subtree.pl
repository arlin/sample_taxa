#!/usr/bin/perl -w 
#

=head1 NAME

ot_induced_subtree.pl - get ottIds for named species using OpenTree web services

=head1 SYNOPSIS

    ot_induced_subtree.pl --ids "<id1>[,<id2>]*" --file FILE

    --help, --?         print help message
    --open              invoke system to open file in tree viewer (see below)

Examples:

    ot_induced_subtree.pl --ids '633213,796660,292504'  
	perldoc ot_induced_subtree.pl (to read the full docs)
	
=head1 DESCRIPTION

This is just a wrapper for OpenTree's induced_tree service.  It returns the induced tree for the identified taxa on stdout, and also puts it in a file.  

If no output file name is given, the results go in induced_subtree.nwk.

The "open" flag invokes system( "open \$outfile" ) which will work on a Mac if you have set your Mac to open .nwk files with your installed tree viewer (ctrl-click on .nwk file, choose "get info", choose "open with" and select your viewer, click "change all" to apply to all files with the same extension). 


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
my $open = 0; 

my $outfile = "induced_subtree.nwk";
GetOptions(
    "ids=s" => \$ids, 
    "file=s" => \$outfile, 
    "open!" => \$open, 
    "help|?" => \$help
    ) or pod2usage( "Invalid command-line options." );
pod2usage() if defined( $help ); 

my $script = $0; 
$script =~ s#^.*/##; 

# construct the command 
#
my $base_url = "http://api.opentreeoflife.org/v2/tree_of_life/induced_subtree"; 
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

# let's put this in a file 
open(my $fh, ">", $outfile ) or die "cannot open > $outfile: $!";
printf( $fh $newick ); 
printf( STDERR "The tree from executing the command ($command) is in $outfile\n" ); 

system( "open $outfile" ) if $open;  

# output and exit
printf( "%s\n", $newick ); 
exit; 
