###############################################################################
## Makefile for Nynorsk--Bokmål
###############################################################################

LANG1=nno
# nno_a har a-endingar i infinitiv, nno_e har e-endingar (standard):
LANG1evi=nno_e_vi
LANG1eme=nno_e_me
LANG1ame=nno_a_me
LANG1avi=nno_a_vi
LANG2=nob
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)
PREFIX1e1a=$(LANG1e)-$(LANG1)
PREFIX1a1e=$(LANG1)-$(LANG1e)
PREFIX2ame=$(LANG2)-$(LANG1ame)
PREFIX2evi=$(LANG2)-$(LANG1evi)
PREFIX2eme=$(LANG2)-$(LANG1eme)
PREFIX2avi=$(LANG2)-$(LANG1avi)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = $(TARGETS_PREFIX1) $(TARGETS_PREFIX2)

TARGETS_PREFIX1 =                                             \
     $(PREFIX1).automorf.bin                                  \
     $(PREFIX1).rlx.bin                                       \
     $(PREFIX1).prob                                          \
     $(PREFIX1).autolex.bin                                   \
     $(PREFIX1).autobil.bin                                   \
     $(PREFIX1).t1x.bin $(PREFIX1).t2x.bin $(PREFIX1).t3x.bin \
     $(PREFIX1).autogen.bin

TARGETS_PREFIX2_EXCEPTGEN =                                   \
     $(PREFIX2).automorf.bin                                  \
     $(PREFIX2).seg.rlx.bin                                   \
     $(PREFIX2).rlx.bin                                       \
     $(PREFIX2).prob                                          \
     $(PREFIX2).autolex.bin                                   \
     $(PREFIX2).autobil.bin                                   \
     $(PREFIX2).t1x.bin $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin \
     $(PREFIX2).autopgen.bin

TARGETS_PREFIX2 =                 \
     $(TARGETS_PREFIX2_EXCEPTGEN) \
     $(PREFIX2ame).autogen.bin    \
     $(PREFIX2evi).autogen.bin    \
     $(PREFIX2eme).autogen.bin    \
     $(PREFIX2avi).autogen.bin

$(PREFIX1): $(TARGETS_PREFIX1)
$(PREFIX2): $(TARGETS_PREFIX2)

# Debug/development goals:
e: modes/$(PREFIX1).mode	# build just nob-nno_e
	cd $(AP_SRC1) && ${MAKE} $(LANG1evi).autogen.bin $(LANG1).autopgen.bin
	cd $(AP_SRC2) && ${MAKE} $(LANG2).automorf.bin  $(LANG2).seg.rlx.bin $(LANG2).rlx.bin $(LANG2).prob
	${MAKE} $(TARGETS_PREFIX2_EXCEPTGEN) $(PREFIX2evi).autogen.bin
r: modes/$(PREFIX1).mode $(PREFIX2).autolex.bin $(PREFIX2).t1x.bin $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin # build just transfer and rlx files for nob-nno(_e)
	cd $(AP_SRC2) && ${MAKE} $(LANG2).seg.rlx.bin $(LANG2).rlx.bin
	${MAKE} $(PREFIX2).seg.rlx.bin $(PREFIX2).rlx.bin

# This include defines goals for install-modes, .deps/.d and .mode files:
@ap_include@

###############################################################################
## Monolingual transducers
###############################################################################

# -------------------
# Nynorsk analysis:
# ---------------------
$(PREFIX1).automorf.bin: $(AP_SRC1)/$(LANG1).automorf.bin $(PREFIX1).autobil.bin
	lt-trim $^ $@

# -------------------
# Nynorsk generation:
# ---------------------
$(PREFIX2ame).autogen.bin: $(AP_SRC1)/$(LANG1).autogen.bin
	cp $< $@

$(PREFIX2evi).autogen.bin: $(AP_SRC1)/$(LANG1evi).autogen.bin
	cp $< $@

$(PREFIX2eme).autogen.bin: $(AP_SRC1)/$(LANG1eme).autogen.bin
	cp $< $@

$(PREFIX2avi).autogen.bin: $(AP_SRC1)/$(LANG1avi).autogen.bin
	cp $< $@

$(PREFIX2).autopgen.bin: $(AP_SRC1)/$(LANG1).autopgen.bin
	cp $< $@

# -------------------
# Bokmål analysis:
# ---------------------
$(PREFIX2).automorf.bin: $(AP_SRC2)/$(LANG2).automorf.bin $(PREFIX2).autobil.bin
	lt-trim $^ $@

# -------------------
# Bokmål generation:
# ---------------------
$(PREFIX1).autogen.bin: $(AP_SRC2)/$(LANG2).autogen.bin
	cp $< $@


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

$(PREFIX2).seg.rlx.bin: $(AP_SRC2)/$(LANG2).seg.rlx.bin
	cp $< $@

$(PREFIX2).rlx.bin: $(AP_SRC2)/$(LANG2).rlx.bin
	cp $< $@

###############################################################################
## Bilingual dictionaries
###############################################################################

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@


###############################################################################
## Lexical selection rules
###############################################################################

$(PREFIX1).autolex.bin: $(BASENAME).$(PREFIX1).lrx
	lrx-comp $< $@

$(PREFIX2).autolex.bin: $(BASENAME).$(PREFIX2).lrx
	lrx-comp $< $@

###############################################################################
## Structural transfer rules
###############################################################################

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t2x.bin: $(BASENAME).$(PREFIX1).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).t3x.bin: $(BASENAME).$(PREFIX1).t3x
	apertium-validate-postchunk $<
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
## Distribution
###############################################################################

EXTRA_DIST=$(BASENAME).$(PREFIX1).dix \
	   $(BASENAME).$(PREFIX1).t1x \
	   $(BASENAME).$(PREFIX1).t2x \
	   $(BASENAME).$(PREFIX1).t3x \
	   $(BASENAME).$(PREFIX2).t1x \
	   $(BASENAME).$(PREFIX2).t2x \
	   $(BASENAME).$(PREFIX2).t3x \
	   $(BASENAME).$(PREFIX1).lrx \
	   $(BASENAME).$(PREFIX2).lrx \
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
	$(BASENAME).$(PREFIX2).t1x \
	$(BASENAME).$(PREFIX2).t2x \
	$(BASENAME).$(PREFIX2).t3x

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local: install-modes


###############################################################################
## Cleanup
###############################################################################

CLEANFILES = $(TARGETS_COMMON)
clean-local:
	-rm -rf .deps modes

###############################################################################
## Test
###############################################################################

test: all
	echo "Såg ho ikkje orda? Dei smååt nyplanta hygge." | apertium -d . nno-nob | tee .test-mt
	@echo "Så hun ikke ordene? De småspiste nyplantet hygge." > .test-ref
	@diff .test-ref .test-mt
	echo "Jeg har åler i min luftputebåt. Det er bevisst, sier myndighetene." | apertium -d . nob-nno_e | tee .test-mt
	@echo "Eg har ålar i luftputebåten min. Det er medvite, seier styresmaktene." > .test-ref
	@diff .test-ref .test-mt
	@rm .test-ref .test-mt
	t/bidix-sanity
	t/hash-count
	t/wer-loss
