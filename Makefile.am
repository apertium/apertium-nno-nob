###############################################################################
## Makefile for Nynorsk--Bokmål
###############################################################################

LANG1=nno
LANG2=nob
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_PREFS=prefs/$(PREFIX2).xml \
	      prefs/$(PREFIX2)_e.xml

TARGETS_COMMON = $(TARGETS_PREFIX1) $(TARGETS_PREFIX2)

TARGETS_PREFIX1 =                                             \
     $(PREFIX1).automorf.bin                                  \
     $(PREFIX1).seg.rlx.bin                                   \
     $(PREFIX1).rlx.bin                                       \
     $(PREFIX1).prob                                          \
     $(PREFIX1).autolex.bin                                   \
     $(PREFIX1).autobil.bin                                   \
     $(PREFIX1).t1x.bin $(PREFIX1).t2x.bin $(PREFIX1).t3x.bin \
     $(PREFIX1).autogen.bin

TARGETS_PREFIX2_FAST =                \
     $(LANG1).autoseq.bin             \
     $(PREFIX2).postlex.bin           \
     $(PREFIX2).autolex.bin           \
     $(PREFIX2).autopgen.bin          \
     $(PREFIX2).autoseq.bin           \
     $(PREFIX2).autoseq-trace.bin           \
     $(PREFIX2).biprefs.rlx.bin       \
     $(PREFIX2).e_vi_genprefs.rlx.bin \
     $(PREFIX2).genprefs.rlx.bin      \
     $(PREFIX2).prob                  \
     $(PREFIX2).refsyn.t1x.bin        \
     $(PREFIX2).rlx.bin               \
     $(PREFIX2).seg.rlx.bin           \
     $(PREFIX2).syn.rlx.bin           \
     $(PREFIX2).t1x.bin               \
     $(PREFIX2).t2x.bin               \
     $(PREFIX2).t3x.bin               \
     merge-laws.autoseq.bin           \
     capstag.autoseq.bin              \
     capstag.rlx.bin                  \
     merge-names.rlx.bin              \
     merge-quotes.rlx.bin             \
     prefs/$(PREFIX2).xml

TARGETS_PREFIX2 =                                             \
     $(PREFIX2).automorf.bin                                  \
     $(PREFIX2).autogen.bin                                   \
     $(PREFIX2).autobil.bin                                   \
     $(TARGETS_PREFIX2_FAST)

$(PREFIX1): $(TARGETS_PREFIX1)
$(PREFIX2): $(TARGETS_PREFIX2)

# Debug/development goals:
e: modes/$(PREFIX1).mode	# build just nob-nno_e
	cd $(AP_SRC1) && ${MAKE} $(LANG1).e_vi_prefs.rlx.bin $(LANG1).prefs.rlx.bin $(LANG1).autogen.bin $(LANG1).autopgen.bin
	cd $(AP_SRC2) && ${MAKE} $(LANG2).seg.rlx.bin $(LANG2).syn.rlx.bin $(LANG2).rlx.bin $(LANG2).automorf.bin $(LANG2).prob
	${MAKE} $(TARGETS_PREFIX2)
r: modes/$(PREFIX1).mode
	cd $(AP_SRC1) && ${MAKE} $(LANG1).e_vi_prefs.rlx.bin $(LANG1).prefs.rlx.bin $(LANG1).autopgen.bin
	cd $(AP_SRC2) && ${MAKE} $(LANG2).seg.rlx.bin $(LANG2).syn.rlx.bin $(LANG2).rlx.bin
	${MAKE} $(TARGETS_PREFIX2_FAST)

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## Monolingual transducers
###############################################################################

.deps/pass-through-genmerged.lsx.bin: pass-through-genmerged.lsx
	lt-comp lr $^ $@

# -------------------
# Nynorsk analysis:
# ---------------------
$(PREFIX1).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin .deps/$(PREFIX1).autobil.bin
	lt-trim --match-section=regex@standard $^ $@

# -------------------
# Nynorsk generation:
# ---------------------
$(PREFIX2).autogen.bin: $(AP_SRC1)/$(LANG1).autogen.bin .deps/pass-through-genmerged.lsx.bin
	lt-append $^ $@

$(PREFIX2).autopgen.bin: $(AP_SRC1)/$(LANG1).autopgen.bin
	cp $< $@

# -------------------
# Bokmål analysis:
# ---------------------
$(PREFIX2).automorf.bin: $(AP_SRC2)/$(LANG2).automorf.bin .deps/$(PREFIX2).autobil.bin
	lt-trim --match-section=regex@standard $^ $@

# -------------------
# Bokmål generation:
# ---------------------
$(PREFIX1).autogen.bin: $(AP_SRC2)/$(LANG2).autogen.bin .deps/pass-through-genmerged.lsx.bin
	lt-append $^ $@


###############################################################################
## Tagger models
###############################################################################

$(PREFIX1).prob: $(AP_SRC1)/$(LANG1).prob
	cp $< $@

$(PREFIX2).prob: $(AP_SRC2)/$(LANG2).prob
	cp $< $@


###############################################################################
## Disambiguation rules
###############################################################################

$(PREFIX1).rlx.bin: $(AP_SRC1)/$(LANG1).rlx.bin
	cp $< $@

$(PREFIX1).%.rlx.bin: $(AP_SRC1)/$(LANG1).%.rlx.bin
	cp $< $@

$(PREFIX2).rlx.bin: $(AP_SRC2)/$(LANG2).rlx.bin
	cp $< $@

$(PREFIX2).%.rlx.bin: $(AP_SRC2)/$(LANG2).%.rlx.bin
	cp $< $@

###############################################################################
## Separable / discontiguous multiwords
###############################################################################

$(PREFIX1).autoseq.bin: $(BASENAME).$(PREFIX1).lsx
	lsx-comp lr $< $@

$(PREFIX2).autoseq.bin: $(BASENAME).$(PREFIX2).lsx
	lsx-comp lr $< $@


.deps/trace-$(BASENAME).$(PREFIX2).lsx: $(BASENAME).$(PREFIX2).lsx .deps/.d
	awk '/^ *<section/{s++} s&&/^ *<\/e>/{printf "<p><l></l><r>END</r></p>"} {print}' $< >$@

$(PREFIX2).autoseq-trace.bin: .deps/trace-$(BASENAME).$(PREFIX2).lsx
	lsx-comp --debug lr $< $@

$(LANG1).autoseq.bin: $(BASENAME).$(LANG1).lsx
	lsx-comp lr $< $@

$(PREFIX2).postlex.bin: $(BASENAME).$(PREFIX2)-postlex.lsx
	lsx-comp lr $< $@

# Language-general (at least for nob-nno and nno-nob):
capstag.autoseq.bin: $(BASENAME).capstag.lsx
	lsx-comp lr $< $@

.deps/laws.lsx: $(BASENAME).laws.txt laws2lsx.awk .deps/.d
	awk -f laws2lsx.awk $< >$@
merge-laws.autoseq.bin: .deps/laws.lsx
	lsx-comp lr $< $@

merge-names.rlx.bin: merge-names.rlx
	cg-comp $< $@

merge-quotes.rlx.bin: merge-quotes.rlx
	cg-comp $< $@

###############################################################################
## Bilingual dictionaries
###############################################################################

.deps/pass-through-bimerged.lsx.bin: pass-through-bimerged.lsx
	lt-comp lr $^ $@

.deps/$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix .deps/.d
	apertium-validate-dictionary $<
	lt-comp lr $< $@

.deps/$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix .deps/.d
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFIX1).autobil.bin: .deps/$(PREFIX1).autobil.bin .deps/pass-through-bimerged.lsx.bin
	lt-append $^ $@

$(PREFIX2).autobil.bin: .deps/$(PREFIX2).autobil.bin .deps/pass-through-bimerged.lsx.bin
	lt-append $^ $@

###############################################################################
## Variant preferences
###############################################################################

$(PREFIX2).biprefs.rlx.bin: $(BASENAME).$(PREFIX2).biprefs.rlx
	cg-comp $< $@

$(PREFIX2).e_vi_genprefs.rlx.bin: $(AP_SRC1)/$(LANG1).e_vi_prefs.rlx.bin
	cp $< $@

$(PREFIX2).genprefs.rlx.bin: $(AP_SRC1)/$(LANG1).prefs.rlx.bin
	cp $< $@

###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	apertium-validate-lrx $<
	lrx-comp $< $@

$(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
	apertium-validate-lrx $<
	lrx-comp $< $@

###############################################################################
## Structural transfer rules
###############################################################################

capstag.rlx.bin: capstag.rlx
	cg-comp $< $@

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@


$(PREFIX2).refsyn.t1x.bin: $(BASENAME).$(PREFIX2).refsyn.t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@

###############################################################################
## Preferences
###############################################################################

$(LANG1).preferences.xml: $(AP_SRC1)/$(LANG1).preferences.xml
	cp $< $@

prefs/$(PREFIX2).xml: $(LANG1).preferences.xml $(PREFIX2).preferences.xml merge-prefs.xslt
	$(MKDIR_P) prefs
	xsltproc --stringparam with-file $<  merge-prefs.xslt  $(PREFIX2).preferences.xml >$@

prefs/$(PREFIX2)_e.xml: $(LANG1).preferences.xml $(PREFIX2).preferences.xml merge-prefs.xslt
	$(MKDIR_P) prefs
	xsltproc --stringparam with-file $<  merge-prefs.xslt  $(PREFIX2).preferences.xml >$@

###############################################################################
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(PREFIX1).dix \
	   $(BASENAME).$(PREFIX1).t1x \
	   $(BASENAME).$(PREFIX1).t2x \
	   $(BASENAME).$(PREFIX1).t3x \
	   $(BASENAME).$(PREFIX2).refsyn.t1x \
	   $(BASENAME).$(PREFIX2).t1x \
	   $(BASENAME).$(PREFIX2).t2x \
	   $(BASENAME).$(PREFIX2).t3x \
	   $(BASENAME).$(PREFIX1).lrx \
	   $(BASENAME).$(PREFIX2).lrx \
	   $(PREFIX2).preferences.xml \
	   merge-prefs.xslt           \
	   modes.xml

###############################################################################
## Installation
###############################################################################

apertium_nno_nobdir=$(prefix)/share/apertium/$(BASENAME)/

# Files which should be installed to $(prefix)/share/apertium/$(BASENAME)/:
apertium_nno_nob_DATA=$(TARGETS_COMMON) \
	$(BASENAME).$(PREFIX1).t1x \
	$(BASENAME).$(PREFIX1).t2x \
	$(BASENAME).$(PREFIX1).t3x \
	$(BASENAME).$(PREFIX2).refsyn.t1x \
	$(BASENAME).$(PREFIX2).t1x \
	$(BASENAME).$(PREFIX2).t2x \
	$(BASENAME).$(PREFIX2).t3x

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode $(TARGETS_PREFS)

install-data-local: install-modes
	$(MKDIR_P) $(DESTDIR)$(apertium_modesdir)/../prefs
	$(INSTALL_DATA) $(TARGETS_PREFS) $(DESTDIR)$(apertium_modesdir)/../prefs

###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all test-progression
	t/bidix-sanity
	t/hash-count
	t/wer-loss

test-progression: $(PREFIX2)
	t/progression translate
	THRESHOLD=10 t/progression diff-expected

update-progression: $(PREFIX2)
	t/progression translate
	t/progression update
