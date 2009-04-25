#!/usr/bin/python
# coding=utf-8
# -*- encoding: utf-8 -*-

import sys, codecs, copy;

# sys.stdin  = codecs.getreader('utf-8')(sys.stdin);
# sys.stdout = codecs.getwriter('utf-8')(sys.stdout);
# sys.stderr = codecs.getwriter('utf-8')(sys.stderr);

coverage = 90.0;

if len(sys.argv) == 4: #{
	hitparade = sys.argv[1];
	dict = sys.argv[2];
	coverage = float(sys.argv[3]);
elif len(sys.argv) == 3: #{
	hitparade = sys.argv[1];
	dict = sys.argv[2];
else: #{
	print 'dictionary-trim.py <hitparade> <dict> [<coverage>]';
	sys.exit(-1);
#}

total = 0.0;
counts = {};

total = 0.0;
counts = {};

for line in file(hitparade).read().split('\n'): #{
	if len(line) < 2: #{
		continue;
	#}
	row = line.strip().split(' ');
	if len(row) < 2: #{
		continue;
	#}

	counts[row[1]] = float(row[0]);
	total = total + counts[row[1]];

#	print total , row[0] , row[1];
#}

fraction = (total / 100.0) * coverage;

print '<!-- total: ' , total , ' ; fraction: ' , fraction , ' -->';

del counts;
counts = {};
total = 0.0;
n_lemma = 0;

for line in file(hitparade).read().split('\n'): #{
        if len(line) < 2: #{
                continue;
        #}
        row = line.strip().split(' ');
        if len(row) < 2: #{
                continue;
        #}
	
	counts[row[1]] = float(row[0]);
	total = total + counts[row[1]];
	
        #	print line;
	
	n_lemma = n_lemma + 1;
	# <spectie> because working with ~30k words is harder than
	# working with ~6k words:
	if len(counts) >= 9000:
		break;
	# and 90% coverage gave me ~18k.. full dix is ~83k though.
	
	if total >= fraction: #{
		break;
	#}
#}

infreq = '';


for line in file(dict).read().split('\n'): #{
	if line.count('</dictionary>') > 0: #{

		print '  <section id="infrequent" type="standard">';
		print infreq;
		print '  </section>';
	#}	
		
	if (line.count('<e lm') < 1) or (line.count('__vblex"') < 1 and line.count('__n"') < 1): #{
		print line;
		continue;
	#}
        lemma = line.replace('lm="', '@').replace('"', '@').split('@')[1].lower();
	
	if lemma in counts: #{
		print line;
	else: #{
		infreq = infreq + line + '\n'; 	
	#}

#}
