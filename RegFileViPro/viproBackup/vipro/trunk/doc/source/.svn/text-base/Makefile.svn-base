#
# $Id: Makefile,v 1.1.1.1 2009/05/02 21:21:40 mrc4328 Exp $
#
# Makefile for converting tex files to PDF
#
# approx-logic-08.pdf # tcad-07.pdf  vts-06.pdf date-07.pdf


#all:	dac-orxor-10.pdf 
all:	ViPro_UG.pdf 

#
# We want our main "dvi" to depend on all the "tex" sources which get input
#
ViPro_UG.dvi: *.tex
dac-orxor-10.dvi: *.tex
date-tddb-10.dvi: *.tex
iccad-09.dvi: *.tex
dac-09.dvi: *.tex
dac-06.dvi: *.tex
tcad.dvi: *.tex
vts-06.dvi: *.tex
selse-06.dvi: *.tex
date-07.dvi: *.tex
ced-itc-08.dvi: *.tex
ced-date-09.dvi: *.tex *.bib

#
# Now provide the rules for building the various targets and
# intermediate targets
#

%.dvi : %.tex
	latex $<
#	bibtex $*
#	bibtex $*
	latex $<
	latex $<

%.ps : %.dvi
	dvips -Ppdf -G0 -j0 -o $@ $<

%.pdf : %.ps
	ps2pdf -dCompatibilityLevel=1.2 -dSubsetFonts=true -dEmbedAllFonts=true -dMaxSubsetPct=100 $< $@
	# ps2pdf -dCompatibilityLevel=1.2 -dProcessColorModel=/DeviceGray -dSubsetFonts=true -dEmbedAllFonts=true -dMaxSubsetPct=100 $< $@

clean:
	-rm -f *.dvi *.log *.aux *.bbl *.blg *.ps *.pdf *.out

#
# Make sure that we don't dispose of our ".ps" intermediate target
#

.PRECIOUS: %.ps
