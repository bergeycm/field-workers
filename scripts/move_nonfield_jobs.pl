#!/usr/bin/perl

use strict;
use warnings;

use HTML::TreeBuilder;
use File::Copy;

my $nonfield_dir =  "data/primate_jobs/nonfield/";
mkdir $nonfield_dir;

for (my $i = 1; $i <= 9999; $i++) {

    my $filename = "data/primate_jobs/" . $i . ".html";
    
    # Skip if job doesn't exist
    if (! -e $filename) {
        next;
    }

    print "--- $i ---\n";

    my $html = HTML::TreeBuilder->new;
    my $root = $html->parse_file($filename);

    my $body = $root->find('body');
    
    # Find category, such as "Positions Available"
    my $cat = $body->look_down(
        '_tag', 'h1',
        sub {
            0 < grep { ref($_) and $_->tag eq 'br' }
            $_[0]->content_list
        }
    );
    
    my $cat_text = $cat->content_array_ref->[2];
    
    # Find title of job
    my $title = $body->look_down('_tag', 'h2');
    
    my $title_text = $title->content_array_ref->[0];
    
    print "$title_text\n";
    
    open my $flags, '<', "data/nonfield_flags.txt";
    chomp(my @flags = <$flags>);
    close $flags;
    
    my $to_skip = 0;
    foreach my $flag (@flags) {
        $to_skip = 1 if $title_text =~ /$flag/i;
    }
    
    # Remove "Positions Wanted" posts from job seekers
    if ($cat_text !~ /Positions Available/ || $to_skip) {

        print STDERR "Moving $filename...\n";
        print STDERR "Skipping [$title_text] due to match with flag\n";
        
        my $new_filename = $nonfield_dir . $i . ".html";
        
        move($filename, $new_filename) 
            or die "ERROR: Could not move HTML file to $nonfield_dir: $!\n";
    }
    
}

exit;
