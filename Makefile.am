VERSION=0.6.5
LANG1=nn
LANG2=nb
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = $(PREFIX1).automorf.bin $(PREFIX1).rlx.bin \
     $(PREFIX1).autobil.bin $(PREFIX1).t1x.bin $(PREFIX1).autogen-no-cp.bin \
     $(PREFIX2).automorf-no-cp.bin $(PREFIX2).rlx.bin \
     $(PREFIX2).autobil.bin $(PREFIX2).t1x.bin $(PREFIX2).autogen.bin

.deps/$(BASENAME).$(LANG2).dix: $(BASENAME).$(LANG2).dix rem-compounds.xsl
	if [ ! -d .deps ]; then mkdir .deps; fi
	xsltproc rem-compounds.xsl $(BASENAME).$(LANG2).dix > $@

# nn-nb
$(PREFIX1).automorf.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	lt-comp lr $(BASENAME).$(LANG1).dix $@

$(PREFIX1).rlx.bin: $(BASENAME).$(PREFIX1).rlx
	cg-comp $(BASENAME).$(PREFIX1).rlx $@

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp lr $(BASENAME).$(PREFIX1).dix $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

$(PREFIX1).autogen-no-cp.bin: .deps/$(BASENAME).$(LANG2).dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG2).dix
	lt-comp rl .deps/$(BASENAME).$(LANG2).dix $@


# nb-nn
$(PREFIX2).automorf-no-cp.bin: .deps/$(BASENAME).$(LANG2).dix
	apertium-validate-dictionary .deps/$(BASENAME).$(LANG2).dix
	lt-comp lr .deps/$(BASENAME).$(LANG2).dix $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx
	cg-comp $(BASENAME).$(PREFIX2).rlx $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp rl $(BASENAME).$(PREFIX1).dix $@

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFIX2).autogen.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	lt-comp rl $(BASENAME).$(LANG1).dix $@


# nn-nb-cp
$(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp rl $(BASENAME).$(LANG2).dix $@

# nb-nn-cp
$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp lr $(BASENAME).$(LANG2).dix $@

cp.t1x.bin: cp.t1x
	apertium-validate-transfer cp.t1x
	apertium-preprocess-transfer cp.t1x $@

cp.t2x.bin: cp.t2x
	apertium-validate-interchunk cp.t2x
	apertium-preprocess-transfer cp.t2x $@

cp.t3x.bin: cp.t3x
	apertium-validate-postchunk cp.t3x
	apertium-preprocess-transfer cp.t3x $@

TARGETS_CP = $(PREFIX1).autogen.bin $(PREFIX2).automorf.bin \
	cp.t1x.bin cp.t2x.bin cp.t3x.bin

cp: $(TARGETS_CP)

EXTRA_DIST=$(BASENAME).$(LANG1).dix $(BASENAME).$(PREFIX1).dix \
	   $(BASENAME).$(LANG2).dix \
           $(BASENAME).$(PREFIX1).rlx \
           $(BASENAME).$(PREFIX2).rlx \
           $(PREFIX1).prob $(PREFIX2).prob \
	   $(BASENAME).$(PREFIX1).t1x \
	   $(BASENAME).$(PREFIX2).t1x \
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

apertium_nn_nb_DATA=$(PREFIX1).automorf.bin      $(PREFIX2).automorf-no-cp.bin \
		    $(PREFIX1).rlx.bin           $(PREFIX2).rlx.bin \
                    $(PREFIX1).prob              $(PREFIX2).prob \
                    $(PREFIX1).autobil.bin       $(PREFIX2).autobil.bin \
                    $(PREFIX1).autogen-no-cp.bin $(PREFIX2).autogen.bin \
		    $(PREFIX1).t1x.bin           $(PREFIX2).t1x.bin \
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
	rm $(PREFIX1).mode $(PREFIX2).mode
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(DESTDIR)$(apertium_nn_nbdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(DESTDIR)$(apertium_nn_nbdir)


CLEANFILES = -rf $(TARGETS_COMMON) $(TARGETS_CP) modes .deps
