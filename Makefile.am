VERSION=0.7.0
LANG1=nn
# nn_a har a-endingar i infinitiv, nn_e har e-endingar (standard):
LANG1e=nn_e
LANG1a=nn_a
LANG2=nb
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
     $(PREFIX1).autogen-no-cp.bin \
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

.deps/$(BASENAME).$(LANG2)-no-cp.dix: $(BASENAME).$(LANG2).dix rem-compounds.xsl .deps/.d
	xsltproc rem-compounds.xsl $(BASENAME).$(LANG2).dix > $@

.deps/$(BASENAME).$(LANG1e)-no-cp.dix: $(BASENAME).$(LANG1).dix alt.xsl .deps/.d
	xsltproc --stringparam alt $(LANG1e) alt.xsl $(BASENAME).$(LANG1).dix | xsltproc rem-compounds.xsl - > $@

.deps/$(BASENAME).$(LANG1)-no-cp.dix: $(BASENAME).$(LANG1).dix alt.xsl .deps/.d
	xsltproc --stringparam alt $(LANG1a) alt.xsl $(BASENAME).$(LANG1).dix | xsltproc rem-compounds.xsl - > $@

.deps/$(BASENAME).$(PREFIX1).dix: $(BASENAME).$(PREFIX1).dix lexchoicebil.xsl .deps/.d
	xsltproc lexchoicebil.xsl $(BASENAME).$(PREFIX1).dix > $@

# nn-nb
$(PREFIX1).automorf-no-cp.bin: .deps/$(BASENAME).$(LANG1)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG1)-no-cp.dix
	lt-comp lr .deps/$(BASENAME).$(LANG1)-no-cp.dix $@

$(PREFIX1).rlx.bin: $(BASENAME).$(PREFIX1).rlx
	cg-comp $(BASENAME).$(PREFIX1).rlx $@

$(PREFIX1).autobil.bin: .deps/$(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary .deps/$(BASENAME).$(PREFIX1).dix
	lt-comp lr .deps/$(BASENAME).$(PREFIX1).dix $@

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFIX1).autogen-no-cp.bin: .deps/$(BASENAME).$(LANG2)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG2)-no-cp.dix
	lt-comp rl .deps/$(BASENAME).$(LANG2)-no-cp.dix $@


# nb-nn
$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp lr $(BASENAME).$(LANG2).dix $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx
	cg-comp $(BASENAME).$(PREFIX2).rlx $@

$(PREFIX2).autobil.bin: .deps/$(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary .deps/$(BASENAME).$(PREFIX1).dix
	lt-comp rl .deps/$(BASENAME).$(PREFIX1).dix $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

$(PREFIX2).t2x.bin: $(BASENAME).$(PREFIX2).t2x
	apertium-validate-interchunk $(BASENAME).$(PREFIX2).t2x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t2x $@

$(PREFIX2).t3x.bin: $(BASENAME).$(PREFIX2).t3x
	apertium-validate-postchunk $(BASENAME).$(PREFIX2).t3x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t3x $@

$(PREFIX2).autogen-no-cp.bin: .deps/$(BASENAME).$(LANG1)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG1)-no-cp.dix
	lt-comp rl .deps/$(BASENAME).$(LANG1)-no-cp.dix $@

# nb-nn_e
$(PREFIX2e).autogen-no-cp.bin: .deps/$(BASENAME).$(LANG1e)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG1e)-no-cp.dix
	lt-comp rl .deps/$(BASENAME).$(LANG1e)-no-cp.dix $@



# nn-nb-cp TODO
# $(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
# 	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
# 	lt-comp rl $(BASENAME).$(LANG2).dix $@


$(PREFIX2).automorf-no-cp.bin: .deps/$(BASENAME).$(LANG2)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG2)-no-cp.dix
	lt-comp lr .deps/$(BASENAME).$(LANG2)-no-cp.dix $@

TARGETS_NOCP = $(PREFIX2).automorf-no-cp.bin

nocp: $(TARGETS_NOCP)

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
	   modes.xml alt.xsl rem-compounds.xsl lexchoicebil.xsl

apertium_nn_nbdir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_nn_modesdir=$(prefix)/share/apertium/modes/

modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

apertium_nn_nb_DATA=$(TARGETS_COMMON) \
                    $(PREFIX1).prob \
                    $(PREFIX2).prob \
		    modes.xml

# All modes are created by the same goal, listing several will just give problems with make -j2
noinst_DATA=modes/$(PREFIX1).mode

install-data-local:
	mv modes modes.bak
	apertium-gen-modes modes.xml apertium-$(PREFIX1)
	rm -rf modes
	mv modes.bak modes
	test -d $(DESTDIR)$(apertium_nn_modesdir) || mkdir $(DESTDIR)$(apertium_nn_modesdir)
	modes=`xmllint --xpath '//mode[@install="yes"]/@name' modes.xml | sed 's/ *name="\([^"]*\)"/\1.mode /g'`; \
		$(INSTALL_DATA) $$modes $(DESTDIR)$(apertium_nn_modesdir); \
		rm $$modes
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_nn_nbdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(DESTDIR)$(apertium_nn_nbdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t2x $(DESTDIR)$(apertium_nn_nbdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t3x $(DESTDIR)$(apertium_nn_nbdir)


CLEANFILES = $(TARGETS_COMMON) $(TARGETS_NOCP)
clean-local: 
	-rm -rf .deps modes
