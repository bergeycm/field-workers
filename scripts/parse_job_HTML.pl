#!/usr/bin/perl

use strict;
use warnings;

use HTML::TreeBuilder;
use File::Copy;

for (my $i = 1; $i <= 9999; $i++) {

    my $filename = "data/primate_jobs/" . $i . ".html";
    
    # Skip if job doesn't exist
    if (! -e $filename) {
        next;
    }

    print STDERR "--- $i ---\n";

    my $html = HTML::TreeBuilder->new;
    my $root = $html->parse_file($filename);

    my $body = $root->find('body');
    
    # Grab hiring org
    # <p><strong>Hiring Organization</strong>:<br />Duke University</p>
    my @org = ($body->look_down(
        '_tag', 'p',
        sub {
            $_[0]->as_text =~ m{(Hiring|Educational) Organization}
        }
    ));
    
    my $org_text = $org[0]->content_array_ref->[3];
    
    # Grab date posted
    # <p><strong>Date Posted</strong>:<br />2005-09-21</p>
    my @date = ($body->look_down(
        '_tag', 'p',
        sub {
            $_[0]->as_text =~ m{Date Posted}
        }
    ));
    
    my $date_text = $date[0]->content_array_ref->[3];
    
    # Grab Contact information
    # <a href="mailto:___@___.edu"> ___ ___</a>
    my @email = ($body->look_down(
        '_tag', 'a',
        sub {
            $_[0]->attr('href') =~ m{mailto}
        }
    ));
    
    my $email_addy = $email[0]->attr('href');
    $email_addy =~ s/mailto://;
    $email_addy =~ s/^\s+//g;
    $email_addy =~ s/\s+$//g;

    my $name = $email[0]->as_text;
    $name =~ s/^\s+//g;
    $name =~ s/\s+$//g;
    
    # Remove PhD and Dr
    $name =~ s/,*\s*Ph\.*D\.*//;
    $name =~ s/Dr\.*\s//;
    
    # Remove stuff after comma or " - "
    $name =~ s/,.*//;
    $name =~ s/ - .*//;
    
    # Output everything for populating database
    print "$i\t";
    print "\"$org_text\"\t";
    print "\"$name\"\t";
    print "$email_addy\n";
    
    print "\n";
        
}

exit;
