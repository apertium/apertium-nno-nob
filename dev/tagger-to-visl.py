#!/usr/bin/python
# coding=utf-8
# -*- encoding: utf-8 -*-

import sys, codecs, copy, commands;

sys.stdin  = codecs.getreader('utf-8')(sys.stdin);
sys.stdout = codecs.getwriter('utf-8')(sys.stdout);
sys.stderr = codecs.getwriter('utf-8')(sys.stderr);

c = sys.stdin.read(1);

# Process a lexical unit, examples:
#
#  1. ^zadoù/tad<n><m><pl>$
#  2. ^mont da get/mont<vblex><inf># da get$
#  3. ^mat-tre/mat<adj><mf><sp>+tre<adv>$
#
def processWord(c): #{
	superficial = '';
	lemma = '';
	analyses = {};
	tags = '';
	count = 0;

	c = sys.stdin.read(1);
	while c != '/': #{
		superficial = superficial + c;
		c = sys.stdin.read(1);
	#}

	c = sys.stdin.read(1);
#	while c != '<': #{
#		lemma = lemma + c;
#		c = sys.stdin.read(1);
#	#}

	analyses[count] = '';

	while c != '$': #{
		if c == '/': #{
			count = count + 1;
			c = sys.stdin.read(1);
			continue;
		#}
		if count not in analyses: #{
			analyses[count] = '';
		#}
		analyses[count] = analyses[count] + c;
		c = sys.stdin.read(1);
	#}

	print '"<' + superficial + '>"';
	for i in analyses: #{
		#print '**' , analyses[i]
		analyses[i] = analyses[i].replace(' ', '_');
		if analyses[i].count('#') > 0: #{
			lemh = analyses[i].split('<')[0].replace(' ', '_');
			tags = ' '.join(analyses[i].split('<')[1:]).split('#')[0];
			lemq = analyses[i].split('#')[1].replace(' ', '_');
			analyses[i] = lemh + lemq + '<' + tags;
			analyses[i] = analyses[i].replace('>+', '><+').replace('><', ' ').replace('<', '" ').strip('><').replace('" ', ' ').replace('>', '');
		else: #{
			analyses[i] = analyses[i].replace('>+', '><+').replace('><', ' ').replace('<', '" ').strip('><').replace('" ', ' ');
		#}
		print '\t"' + analyses[i].split(' ')[0].replace('_', ' ') + '" ' + ' '.join(analyses[i].split(' ')[1:]); 
	#}
	print '\n'
#}

while c: #{
	# Beginning of a lexical unit
	if c == '^': #{
		processWord(c);
	#}

	# Newline is newline
	if c == '\n': #{
		print '\n';
	#}

	c = sys.stdin.read(1);
#}
