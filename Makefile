# $Id$
NAME=soul
ARCHNAME=$(NAME).tar.gz
ARCHIVE=$(NAME).dtx Makefile $(NAME).txt $(NAME).ins
MAKEIDXOPT=
DVIPSOPT=#-Pcmz -Pamz
DEP=$(NAME).sty

all: $(NAME).sty $(NAME).ps

print: $(NAME).ps
	psbook $(NAME).ps|psnup -2|psselect -e|lpr
	@ echo -n revert paper stack and hit return
	@ read key
	psbook $(NAME).ps|psnup -2|psselect -o -r|lpr

%.ps: %.dvi 
	dvips $(DVIPSOPT) $< -o $@

$(NAME).pdf: $(NAME).dtx $(NAME).sty
	pdflatex $(NAME).dtx

archive:
	@ tar -czf $(ARCHNAME) $(ARCHIVE) 
	@ echo $(ARCHNAME)		

clean: 
	rm -f $(NAME).{log,toc,lot,lof,idx,ilg,ind,aux,blg,bbl,dvi,ins}

distclean: clean
	rm -f $(NAME).{ps,sty,pdf} $(ARCHNAME)


REFWARN = 'Rerun to get cross-references'
LATEXMAX = 5

%.dvi: %.dtx $(DEP)
	latex $< ; true
	RUNS=$(LATEXMAX); \
	while [ $$RUNS -gt 0 ] ; do \
		if grep $(REFWARN) $*.log > /dev/null; \
		then latex $< ; else break; fi; \
		RUNS=`expr $$RUNS - 1`; \
	done

$(NAME).sty: $(NAME).ins soul.dtx
	tex $(NAME).ins

$(NAME).ins:
	latex $(NAME).dtx

