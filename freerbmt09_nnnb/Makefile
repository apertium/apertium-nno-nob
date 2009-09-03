# From http://www.wlug.org.nz/LatexMakefiles
TARGET=freerbmt09_nnnb

# make pdf by default
all: ${TARGET}.pdf

# it doesn't really need the .dvi, but this way all the refs are right
%.pdf : %.dvi
	pdflatex $*

${TARGET}.bbl: apertium.bib
# in case we don't already have a .aux file listing citations
# this should probably be a separate makefile target/dependency instead
# of doing it every time... but *shrug*
	latex ${TARGET}.tex
# get the citations out of the bibliography
	bibtex ${TARGET}
# do it again in case there are out-of-order cross-references
	@latex ${TARGET}.tex

${TARGET}.dvi: ${TARGET}.bbl ${TARGET}.tex
	@latex ${TARGET}.tex

# shortcut, so we can say "make ps"
ps: ${TARGET}.ps

${TARGET}.ps: ${TARGET}.dvi
	@dvips -t a4 ${TARGET}.dvi

clean:
	rm -f ${TARGET}.{log,aux,ps,dvi,bbl,blg,log}

reallyclean: clean
	rm -f ${TARGET}.{ps,pdf}

getbib:
	wget "http://bibsonomy.org/bib/user/unhammer/apertium?bibtex.entriesPerPage=100" -O apertium.bib 

PHONY : ps all clean reallyclean getbib
