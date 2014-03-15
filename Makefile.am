VERSION=0.7.0
LANG1=nno
# nno_a har a-endingar i infinitiv, nno_e har e-endingar (standard):
LANG1e=nno_e
LANG1a=nno_a
LANG2=nob
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)
PREFIX1e1a=$(LANG1e)-$(LANG1)
PREFIX1a1e=$(LANG1)-$(LANG1e)
PREFIX2e=$(LANG2)-$(LANG1e)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = \
     $(PREFIX1).automorf-no-cp.bin \
     $(PREFIX1).rlx.bin \
     $(PREFIX1).autobil.bin $(PREFIX1).t1x.bin \
     $(PREFIX1).autogen.bin \
     $(PREFIX2).automorf.bin \
     $(PREFIX2).rlx.bin \
     $(PREFIX2).autobil.bin $(PREFIX2).t1x.bin $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin \
     $(PREFIX2).autogen-no-cp.bin \
     $(PREFIX2e).autogen-no-cp.bin

# Use this goal for creating .deps, otherwise make -j2 will give problems:
.deps/.d:
	test -d .deps || mkdir .deps
	touch $@

# Prevent the .d file from being removed automatically:
.PRECIOUS: .deps/.d

.deps/$(BASENAME).$(LANG1)-no-cp.dix: $(BASENAME).$(LANG1).dix rem-compounds.xsl .deps/.d
	xsltproc rem-compounds.xsl $(BASENAME).$(LANG1).dix > $@

.deps/$(BASENAME).$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix lexchoicebil.xsl .deps/.d
	xsltproc lexchoicebil.xsl $(BASENAME).$(PREFIX1).dix > $@

# nno-nob
$(PREFIX1).automorf-no-cp.bin: .deps/$(BASENAME).$(LANG1)-no-cp.dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX1).rlx.bin: $(BASENAME).$(PREFIX1).rlx
	cg-comp $< $@

$(PREFIX1).autobil.bin: .deps/$(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@


# nob-nno
$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $<
	lt-comp lr $< $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx
	cg-comp $(BASENAME).$(PREFIX2).rlx $@

$(PREFIX2).autobil.bin: .deps/$(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $<
	lt-comp rl $< $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $<
	apertium-preprocess-transfer $< $@

$(PREFIX2).autogen-no-cp.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp --alt $(LANG1a) rl $< $@

# nob-nno_e
$(PREFIX2e).autogen-no-cp.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $<
	lt-comp --alt $(LANG1e) rl $< $@



# nno-nob-cp TODO
# $(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
# 	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
# 	lt-comp rl $(BASENAME).$(LANG2).dix $@


EXTRA_DIST=$(BASENAME).$(LANG1).dix $(BASENAME).$(PREFIX1).dix \
	   $(BASENAME).$(LANG2).dix \
           $(BASENAME).$(PREFIX1).rlx \
           $(BASENAME).$(PREFIX2).rlx \
           $(PREFIX1).prob $(PREFIX2).prob \
	   $(BASENAME).$(PREFIX1).t1x \
	   $(BASENAME).$(PREFIX2).t1x \
	   $(BASENAME).$(PREFIX2).t2x \
	   $(BASENAME).$(PREFIX2).t3x \
	   $(BASENAME).$(LANG1).tsx \
	   $(BASENAME).$(LANG2).tsx \
	   modes.xml rem-compounds.xsl lexchoicebil.xsl

apertium_nno_nobdir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_modesdir=$(prefix)/share/apertium/modes/

modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

apertium_nno_nob_DATA=$(TARGETS_COMMON) \
                    $(PREFIX1).prob \
                    $(PREFIX2).prob \
		    modes.xml

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local:
	mv modes modes.bak
	apertium-gen-modes modes.xml $(BASENAME)
	rm -rf modes
	mv modes.bak modes
	test -d $(DESTDIR)$(apertium_modesdir) || mkdir $(DESTDIR)$(apertium_modesdir)
	modes=`xmllint --xpath '//mode[@install="yes"]/@name' modes.xml | sed 's/ *name="\([^"]*\)"/\1.mode /g'`; \
		$(INSTALL_DATA) $$modes $(DESTDIR)$(apertium_modesdir); \
		rm $$modes
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_nno_nobdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(DESTDIR)$(apertium_nno_nobdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t2x $(DESTDIR)$(apertium_nno_nobdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t3x $(DESTDIR)$(apertium_nno_nobdir)


CLEANFILES = $(TARGETS_COMMON) $(TARGETS_NOCP)
clean-local: 
	-rm -rf .deps modes
