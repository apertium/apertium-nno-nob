VERSION=0.8.0
LANG1=nn
LANG2=nb
PREFIX1=$(LANG1)-$(LANG2)
PREFIX2=$(LANG2)-$(LANG1)

BASENAME=apertium-$(PREFIX1)

TARGETS_COMMON = $(PREFIX1).automorf.bin $(PREFIX1).autobil.bin $(PREFIX1).autogen.bin \
     $(PREFIX2).automorf.bin $(PREFIX2).autobil.bin \
     $(PREFIX2).autogen.bin \
     $(PREFIX1).t1x.bin $(PREFIX2).rlx.bin \
     $(PREFIX2).t1x.bin

#    $(PREFIX1).autopgen.bin $(PREFIX2).autopgen.bin 

$(PREFIX1).automorf.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	lt-comp lr $(BASENAME).$(LANG1).dix $@

$(PREFIX1).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp lr $(BASENAME).$(PREFIX1).dix $@

$(PREFIX1).autogen.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp rl $(BASENAME).$(LANG2).dix $@

$(PREFIX1).autopgen.bin: $(BASENAME).post-$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG2).dix
	lt-comp lr $(BASENAME).post-$(LANG2).dix $@

$(PREFIX2).rlx.bin: $(BASENAME).$(PREFIX2).rlx
	cg-comp $(BASENAME).$(PREFIX2).rlx $@


$(PREFIX2).automorf.bin: $(BASENAME).$(LANG2).dix
	apertium-validate-dictionary $(BASENAME).$(LANG2).dix
	lt-comp lr $(BASENAME).$(LANG2).dix $@

$(PREFIX2).autobil.bin: $(BASENAME).$(PREFIX1).dix
	apertium-validate-dictionary $(BASENAME).$(PREFIX1).dix
	lt-comp rl $(BASENAME).$(PREFIX1).dix $@

$(PREFIX2).autogen.bin: $(BASENAME).$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).$(LANG1).dix
	lt-comp rl $(BASENAME).$(LANG1).dix $@

$(PREFIX2).autopgen.bin: $(BASENAME).post-$(LANG1).dix
	apertium-validate-dictionary $(BASENAME).post-$(LANG1).dix
	lt-comp lr $(BASENAME).post-$(LANG1).dix $@

$(PREFIX1).t1x.bin: $(BASENAME).$(PREFIX1).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX1).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX1).t1x $@

$(PREFIX2).t1x.bin: $(BASENAME).$(PREFIX2).t1x
	apertium-validate-transfer $(BASENAME).$(PREFIX2).t1x
	apertium-preprocess-transfer $(BASENAME).$(PREFIX2).t1x $@

EXTRA_DIST=$(BASENAME).$(LANG1).dix $(BASENAME).$(PREFIX1).dix \
           $(BASENAME).post-$(LANG1).dix $(BASENAME).post-$(LANG2).dix \
	   $(BASENAME).$(LANG2).dix \
	   $(BASENAME).$(LANG1).dix.xml \
	   $(BASENAME).$(LANG2).dix.xml \
	   $(BASENAME).$(PREFIX1).dix.xml \
           $(PREFIX1).prob $(PREFIX2).prob \
	   $(BASENAME).$(PREFIX1).t1x \
	   $(BASENAME).$(PREFIX2).t1x \
	   $(BASENAME).$(LANG1).tsx \
	   $(BASENAME).$(LANG2).tsx modes.xml

#           $(LANG1)-tagger-data/README $(LANG2)-tagger-data/README 

clean-dicts:
	touch $(BASENAME).$(LANG1).dix $(BASENAME).$(LANG2).dix $(BASENAME).$(PREFIX1).dix
	rm $(BASENAME).$(LANG1).dix
	rm $(BASENAME).$(LANG2).dix
	rm $(BASENAME).$(PREFIX1).dix
	
apertium_nn_nbdir=$(prefix)/share/apertium/apertium-$(PREFIX1)/
apertium_nn_modesdir=$(prefix)/share/apertium/modes/

$(PREFIX1).mode: modes.xml 
	apertium-gen-modes modes.xml
	cp *.mode modes/

$(PREFIX2).mode: modes.xml 
	apertium-gen-modes modes.xml
	cp *.mode modes/

apertium_nn_nb_DATA=$(PREFIX1).automorf.bin $(PREFIX2).automorf.bin \
                    $(PREFIX1).autobil.bin $(PREFIX2).autobil.bin \
                    $(PREFIX1).autogen.bin $(PREFIX2).autogen.bin \
                    $(PREFIX1).prob $(PREFIX2).prob \
		    $(PREFIX1).t1x.bin $(PREFIX2).rlx.bin \
		    $(PREFIX2).t1x.bin \
	            $(PREFIX1).mode $(PREFIX2).mode modes.xml

#                    $(PREFIX1).autopgen.bin 
#                    $(PREFIX2).autopgen.bin 
		  
install-data-local:
	apertium-gen-modes modes.xml apertium-$(PREFIX1)
	$(INSTALL_DATA) $(PREFIX1).mode $(apertium_nn_modesdir)
	$(INSTALL_DATA) $(PREFIX2).mode $(apertium_nn_modesdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX1).t1x $(apertium_nn_nbdir)
	$(INSTALL_DATA) $(BASENAME).$(PREFIX2).t1x $(apertium_nn_nbdir)

CLEANFILES = -rf $(TARGETS_COMMON) modes
