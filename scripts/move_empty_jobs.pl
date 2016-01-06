#!/usr/bin/perl

use strict;
use warnings;

use HTML::TreeBuilder;
use File::Copy;

my $empties_dir =  "data/primate_jobs/empty/";
mkdir $empties_dir;

for (my $i = 1; $i <= 9999; $i++) {

    my $filename = "data/primate_jobs/" . $i . ".html";

    my $html = HTML::TreeBuilder->new;
    my $root = $html->parse_file($filename);

    my $head  = $root->find('head');
    my $title = $head->find('title');
    
    my $title_text = $title->content_array_ref->[0];
    
    # Move "empty" files with following title to subfolder
    #    <title>Primate-Jobs:  -- </title>

    if ($title_text eq "Primate-Jobs: -- ") {
    
        print STDERR "Moving $filename...\n";
        
        my $new_filename = $empties_dir . $i . ".html";
        
        move($filename, $new_filename) 
        	or die "ERROR: Could not move HTML file to $empties_dir: $!\n";
    }
}

exit;
