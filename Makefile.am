VERSION=0.6.5
LANG1=nn
# nn_a har a-endingar i infinitiv, nn_e har e-endingar (standard):
LANG1e=nn_e
LANG1a=nn_a
LANG2=nb
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)
PREFIX2a=$(LANG2)-$(LANG1a)
PREFIX1a=$(LANG1)-$(LANG1a)
PREFIX1e=$(LANG1a)-$(LANG1)
PREFIX2cp=$(LANG2)-$(LANG1)-cp
PREFIX2acp=$(LANG2)-$(LANG1a)-cp

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = \
     $(PREFIX1).automorf-no-cp.bin \
     $(PREFIX1).rlx.bin \
     $(PREFIX1).autobil.bin $(PREFIX1).t1x.bin \
     $(PREFIX1).autogen-no-cp.bin \
     $(PREFIX2).automorf-no-cp.bin \
     $(PREFIX2).automorf.bin \
     $(PREFIX2).rlx.bin \
     $(PREFIX2).autobil.bin $(PREFIX2).t1x.bin $(PREFIX2).t2x.bin $(PREFIX2).t3x.bin \
     $(PREFIX2).autogen-no-cp.bin \
     $(PREFIX2a).autogen-no-cp.bin

# Use this goal for creating .deps, otherwise make -j2 will give problems:
.deps/.d:
	if [ ! -d .deps ]; then mkdir .deps; fi
	touch $@

# Prevent the .d file from being removed automatically:
.PRECIOUS: .deps/.d

.deps/$(BASENAME).$(LANG2)-no-cp.dix: $(BASENAME).$(LANG2).dix rem-compounds.xsl .deps/.d
	xsltproc rem-compounds.xsl $(BASENAME).$(LANG2).dix > $@

.deps/$(BASENAME).$(LANG1)-no-cp.dix: $(BASENAME).$(LANG1).dix alt.xsl .deps/.d
	xsltproc --stringparam alt $(LANG1e) alt.xsl $(BASENAME).$(LANG1).dix | xsltproc rem-compounds.xsl - > $@

.deps/$(BASENAME).$(LANG1a)-no-cp.dix: $(BASENAME).$(LANG1).dix alt.xsl .deps/.d
	xsltproc --stringparam alt $(LANG1a) alt.xsl $(BASENAME).$(LANG1).dix | xsltproc rem-compounds.xsl - > $@

# nn-nb
$(PREFIX1).automorf-no-cp.bin: .deps/$(BASENAME).$(LANG1)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG1)-no-cp.dix
	lt-comp lr .deps/$(BASENAME).$(LANG1)-no-cp.dix $@

$(PREFIX1).rlx.bin: $(BASENAME).$(PREFIX1).rlx
	cg-comp $(BASENAME).$(PREFIX1).rlx $@

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp lr $(BASENAME).$(PREFIX1).dix $@

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFIX1).autogen-no-cp.bin: .deps/$(BASENAME).$(LANG2)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG2)-no-cp.dix
	lt-comp rl .deps/$(BASENAME).$(LANG2)-no-cp.dix $@


# nb-nn
$(PREFIX2).automorf-no-cp.bin: .deps/$(BASENAME).$(LANG2)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG2)-no-cp.dix
	lt-comp lr .deps/$(BASENAME).$(LANG2)-no-cp.dix $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx
	cg-comp $(BASENAME).$(PREFIX2).rlx $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp rl $(BASENAME).$(PREFIX1).dix $@

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

# nb-nn_a
$(PREFIX2a).autogen-no-cp.bin: .deps/$(BASENAME).$(LANG1a)-no-cp.dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG1a)-no-cp.dix
	lt-comp rl .deps/$(BASENAME).$(LANG1a)-no-cp.dix $@


# nn-nb-cp TODO
# $(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
# 	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
# 	lt-comp rl $(BASENAME).$(LANG2).dix $@

# nb-nn-cp
$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp lr $(BASENAME).$(LANG2).dix $@

TARGETS_CP = $(PREFIX2).automorf.bin

cp: $(TARGETS_CP)

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
	   $(BASENAME).$(LANG2).tsx modes.xml

clean-dicts:
	touch $(BASENAME).$(LANG1).dix $(BASENAME).$(LANG2).dix $(BASENAME).$(PREFIX1).dix
	rm $(BASENAME).$(LANG1).dix
	rm $(BASENAME).$(LANG2).dix
	rm $(BASENAME).$(PREFIX1).dix

apertium_nn_nbdir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_nn_modesdir=$(prefix)/share/apertium/modes/

modes/$(PREFIX1).mode: modes.xml
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

modes/$(PREFIX2).mode: modes.xml 
	apertium-validate-modes modes.xml
	apertium-gen-modes modes.xml
	cp *.mode modes/

apertium_nn_nb_DATA=$(PREFIX1).automorf-no-cp.bin $(PREFIX2).automorf-no-cp.bin \
		                                  $(PREFIX2).automorf.bin \
		    $(PREFIX1).rlx.bin            $(PREFIX2).rlx.bin \
                    $(PREFIX1).prob               $(PREFIX2).prob \
                    $(PREFIX1).autobil.bin        $(PREFIX2).autobil.bin \
                    $(PREFIX1).autogen-no-cp.bin  $(PREFIX2).autogen-no-cp.bin \
                                                  $(PREFIX2a).autogen-no-cp.bin \
		    $(PREFIX1).t1x.bin            $(PREFIX2).t1x.bin \
		                                  $(PREFIX2).t2x.bin \
		                                  $(PREFIX2).t3x.bin \
		    modes.xml 

noinst_DATA=modes/$(PREFIX1).mode modes/$(PREFIX2).mode

install-data-local:
	mv modes modes.bak
	apertium-gen-modes modes.xml apertium-$(PREFIX1)
	rm -rf modes
	mv modes.bak modes
	test -d $(DESTDIR)$(apertium_nn_modesdir) || mkdir $(DESTDIR)$(apertium_nn_modesdir)
	$(INSTALL_DATA) $(PREFIX1).mode $(DESTDIR)$(apertium_nn_modesdir)
	$(INSTALL_DATA) $(PREFIX2).mode $(DESTDIR)$(apertium_nn_modesdir)
	$(INSTALL_DATA) $(PREFIX2a).mode $(DESTDIR)$(apertium_nn_modesdir)
	$(INSTALL_DATA) $(PREFIX1a).mode $(DESTDIR)$(apertium_nn_modesdir)
	$(INSTALL_DATA) $(PREFIX1e).mode $(DESTDIR)$(apertium_nn_modesdir)
	$(INSTALL_DATA) $(PREFIX2cp).mode $(DESTDIR)$(apertium_nn_modesdir)
	$(INSTALL_DATA) $(PREFIX2acp).mode $(DESTDIR)$(apertium_nn_modesdir)
	rm $(PREFIX1).mode $(PREFIX2).mode $(PREFIX2a).mode $(PREFIX1a).mode $(PREFIX1e).mode
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_nn_nbdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(DESTDIR)$(apertium_nn_nbdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t2x $(DESTDIR)$(apertium_nn_nbdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t3x $(DESTDIR)$(apertium_nn_nbdir)


CLEANFILES = -rf $(TARGETS_COMMON) $(TARGETS_CP) modes .deps
