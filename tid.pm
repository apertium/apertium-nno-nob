#!/usr/bin/perl -w

# Script to postedit articles translated from
# Bokmål Wikipedia to Nynorsk Wikipedia.

# Usage (in the directory apertium-nn-nb/):
# cat nb-inputarticle | apertium -d . -u nb-nn | ./wikifix-nb-nn.pl | ...

use utf8 ;

#!/usr/bin/perl 
use date::Format;

print time2str("%D", time), "\n"; 
# (prints 10/09/04)

print time2str("%m/%d/%Y", time), "\n"; 
# (prints 10/09/2004) 


#use Time::Local;
#my $time = timelocal($day, $mon, $year);
