#!/usr/bin/python2.5
# coding=utf-8
# -*- encoding: utf-8 -*-

import sys, codecs, copy;

# sys.stdout = codecs.getwriter('utf-8')(sys.stdout);
# sys.stderr = codecs.getwriter('utf-8')(sys.stderr);
# sys.stdin = codecs.getreader('utf-8')(sys.stdin);

seen = {};

for line in sys.stdin.read().split('\n'): #{
	if line.count('<e lm="') > 0:# and line.count('__n"/>') > 0: 
		if line in seen: #{
			#print '-' , line;
			print '';
		else: #{
			seen[line] = 1;
			print line;
		#}	

	else: #{
		print line;
	#}
#}
