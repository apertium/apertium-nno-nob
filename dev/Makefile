# Use "make testvoc" to make the testvoc files.

# To get nb.@ or nn.@ into bidix format, use:
# sed 's/<\([^_>]*\)>/<s n="\1"\/>/' |\
# sed 's/<n_\([^>]*\)>/<s n="n"\/><s n="\1">/' |\
# gsed 's/.*/<e>       <p><l>\0<\/l><r>\0<\/r><\/p><\/e>/'

# Important: check the (bi)slash files before the hash files, since
# any slash implies a hash. Hmm, I should probaby grep -v
# those...


LANG1=nn
LANG2=nb
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)


# nn->nb:
$(PREFIX1).inconsistency : $(PREFIX1).inconsistency.sh
	@echo "This may take a while... the resulting file is typically about 100MB"
	./$(PREFIX1).inconsistency.sh > $@
	@echo "$@ done."

$(PREFIX1).@ : $(PREFIX1).inconsistency
	@echo "finding $@..." 
	@cat $(PREFIX1).inconsistency | grep '@' |sed 's/<n></<n_/g'| sed 's/.*@\([^>]*\).*/\1>/' | uniq > $@

$(PREFIX1).hash : $(PREFIX1).inconsistency
	@echo "finding $@..." 
	@cat $(PREFIX1).inconsistency | grep ' #' |sed 's/<n></<n_/g'| sed 's/.* --------->.*--------->[^#]*#\([^>]*\).*/\1>/' | uniq > $@

$(PREFIX1).bislash : $(PREFIX1).inconsistency
	@echo "finding $@..." 
	@cat $(PREFIX1).inconsistency | grep    ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| sed 's/.*#\([^>]*\).*\/\([^>]*\).*/\1> \2>/' | uniq > $@

$(PREFIX1).slash : $(PREFIX1).inconsistency
	@echo "finding $@..." 
	@cat $(PREFIX1).inconsistency | grep -v ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| sed 's/..*\^\([^>]*\).*/\1>/' | uniq > $@


# nb->nn:
$(PREFIX2).inconsistency : $(PREFIX2).inconsistency.sh
	@echo "This may take a while... the resulting file is typically about 200MB"
	./$(PREFIX2).inconsistency.sh > $@
	@echo "$@ done."

$(PREFIX2).@ : $(PREFIX2).inconsistency
	@echo "finding $@..." 
	@cat $(PREFIX2).inconsistency | grep '@' |sed 's/<n></<n_/g'| sed 's/.*@\([^>]*\).*/\1>/' | uniq > $@

$(PREFIX2).hash : $(PREFIX2).inconsistency
	@echo "finding $@..." 
	@cat $(PREFIX2).inconsistency | grep ' #' |sed 's/<n></<n_/g'| sed 's/.* --------->.*--------->[^#]*#\([^>]*\).*/\1>/' | uniq > $@

$(PREFIX2).bislash : $(PREFIX2).inconsistency
	@echo "finding $@..." 
	@cat $(PREFIX2).inconsistency | grep    ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| sed 's/.*#\([^>]*\).*\/\([^>]*\).*/\1> \2>/' | uniq > $@

$(PREFIX2).slash : $(PREFIX2).inconsistency
	@echo "finding $@..." 
	@cat $(PREFIX2).inconsistency | grep -v ' --------->.*\/.*--------->' | grep '\/' |sed 's/<n></<n_/g'| sed 's/..*\^\([^>]*\).*/\1>/' | uniq > $@


# MWE's are not captured by the inconsistency scripts (really the targets should be $(TRANSLATOR) or something):
$(PREFIX1).mwe : ../$(BASENAME).$(LANG1).dix
	@echo "finding $@..." 
	@cat ../$(BASENAME).$(LANG1).dix |grep '<e lm="[^"]* '|sed 's/">.*/ ./'|sed 's/.*"//'|apertium $(PREFIX1) -d ..| grep '[#@]' > $@ || exit 0

$(PREFIX1).bimwe : ../$(BASENAME).$(PREFIX1).dix
	@echo "finding $@..." 
	@cat ../$(BASENAME).$(PREFIX1).dix|grep '<b/>'|sed 's/.*<l>//'|sed 's/<s.*/ ./'|sed 's/<b\/>/ /g'|apertium $(PREFIX1) -d ..|grep '[#@]' > $@ || exit 0

$(PREFIX2).mwe : ../$(BASENAME).$(LANG2).dix
	@echo "finding $@..." 
	@cat ../$(BASENAME).$(LANG2).dix |grep '<e lm="[^"]* '|sed 's/">.*/ ./'|sed 's/.*"//'|apertium $(PREFIX2) -d ..| grep '[#@]' > $@ || exit 0

$(PREFIX2).bimwe : ../$(BASENAME).$(PREFIX1).dix
	@echo "finding $@..." 
	@cat ../$(BASENAME).$(PREFIX1).dix|grep '<b/>'|sed 's/.*<r>//'|sed 's/<s.*/ ./'|sed 's/<b\/>/ /g'|apertium $(PREFIX2) -d ..|grep '[#@]' > $@ || exit 0



INCONSISTENCY = $(PREFIX1).inconsistency $(PREFIX2).inconsistency

MWETESTS = \
	$(PREFIX2).mwe $(PREFIX2).bimwe \
	$(PREFIX1).mwe $(PREFIX1).bimwe

INCONTESTS = \
	$(PREFIX2).@ $(PREFIX2).hash $(PREFIX2).bislash $(PREFIX2).slash \
	$(PREFIX1).@ $(PREFIX1).hash $(PREFIX1).bislash $(PREFIX1).slash

testvoc : $(INCONTESTS) $(MWETESTS)

wikistats : $(INCONTESTS)
	@echo '|  Nynorsk'
	@wc -l $(PREFIX1).hash $(PREFIX1).@ $(PREFIX1).bislash $(PREFIX1).slash |grep -v "total" |sed "s/^/|/" | sed "s/$(PREFIX1).*//"
	@echo ""
	@echo "|  Bokmål"
	@wc -l $(PREFIX2).hash $(PREFIX2).@ $(PREFIX2).bislash $(PREFIX2).slash |grep -v "total" |sed "s/^/|/" | sed "s/$(PREFIX2).*//"


clean :
	rm -f $(INCONTESTS) $(MWETESTS)

reallyclean : 
	rm -f $(INCONTESTS) $(MWETESTS) $(INCONSISTENCY)
