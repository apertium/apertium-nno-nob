# -*- mode:makefile -*-

TAGGER_UNSUPERVISED_ITERATIONS=8
BASENAME=apertium-nn-nb
LANG1=nn
LANG2=nb
TAGGER=$(LANG1)-tagger-data
PREFIX=$(LANG1)-$(LANG2)

all: $(PREFIX).prob

$(PREFIX).prob: $(BASENAME).$(LANG1).tsx $(TAGGER)/$(LANG1).dic $(TAGGER)/$(LANG1).crp
	apertium-validate-tagger $(BASENAME).$(LANG1).tsx
	apertium-tagger -t $(TAGGER_UNSUPERVISED_ITERATIONS) \
	                   $(TAGGER)/$(LANG1).dic \
	                   $(TAGGER)/$(LANG1).crp \
	                   $(BASENAME).$(LANG1).tsx \
	                   $(PREFIX).prob;

# We append both the cg-proc'd full corpus and the lt-expansion here, this way we should have all ambiguity classes in .dic
$(TAGGER)/$(LANG1).dic: .deps/$(BASENAME).$(LANG1)-no-cp.dix $(PREFIX).automorf-no-cp.bin $(TAGGER)/$(LANG1).crp
	@echo "Expanding the dictionary and filtering ambiguity classes.";
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG1)-no-cp.dix
	apertium-validate-tagger $(BASENAME).$(LANG1).tsx
	lt-expand .deps/$(BASENAME).$(LANG1)-no-cp.dix | grep -v "__REGEXP__\|DUE_TO_LT_PROC_HANG" | grep -v ":<:" |\
	  awk 'BEGIN{FS=":>:|:"}{print $$1 ".";}' | apertium-destxt >$(LANG1).dic.expanded
	@echo "." >>$(LANG1).dic.expanded
	@echo "?" >>$(LANG1).dic.expanded
	@echo ";" >>$(LANG1).dic.expanded
	@echo ":" >>$(LANG1).dic.expanded
	@echo "!" >>$(LANG1).dic.expanded
	@echo "42" >>$(LANG1).dic.expanded
	@echo "," >>$(LANG1).dic.expanded
	@echo "(" >>$(LANG1).dic.expanded
	@echo "\\[" >>$(LANG1).dic.expanded
	@echo ")" >>$(LANG1).dic.expanded
	@echo "\\]" >>$(LANG1).dic.expanded
	<$(LANG1).dic.expanded lt-proc -e $(PREFIX).automorf-no-cp.bin >$(LANG1).dic.expanded.analysed
	<$(TAGGER)/$(LANG1).crp apertium-cleanstream -n |\
	  cat - $(LANG1).dic.expanded.analysed |\
	  apertium-filter-ambiguity $(BASENAME).$(LANG1).tsx > $@
	rm $(LANG1).dic.expanded;

# cg-proc nb-nn eats memory on big corpora; split it into several to hide from the OOM killer
$(TAGGER)/$(LANG1).crp: $(PREFIX).automorf-no-cp.bin $(PREFIX).rlx.bin $(TAGGER)/$(LANG1).crp.txt.xz
	@echo "Analysing and pre-disambiguating the corpus.";
	@echo "This may take some time. Please, take a cup of coffee and come back later.";
	xzcat $(TAGGER)/$(LANG1).crp.txt.xz | split - -l 20000 $(TAGGER)/$(LANG1).crp.split
	for f in $(TAGGER)/$(LANG1).crp.split*; do \
	  apertium-destxt < $$f |\
	    lt-proc -w -e $(LANG1)-$(LANG2).automorf-no-cp.bin |\
	    cg-proc -w $(LANG1)-$(LANG2).rlx.bin >> $(TAGGER)/$(LANG1).crp; \
	  rm -f $$f; \
	done


clean:
	rm -f $(PREFIX).prob $(TAGGER)/$(LANG1).dic $(TAGGER)/$(LANG1).crp
