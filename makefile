DEBUG = no

#
#	Softwares
#
PDFLATEX = xelatex
INDEXTEX = makeindex
GLOSSTEX = makeglossaries

#
#	Folders
#
OTHDIR = other
BINDIR = build
TEMPDIR = $(HOME)/Bureau/Mes_Documents/Programmation/Makefiles/Templates

#
#	Needed files
#
TEX := $(wildcard *.tex)
NAME := $(basename $(notdir $(TEX)))
PDF := $(addsuffix .pdf, $(NAME))
IST := $(addsuffix .log, $(NAME))
IND := $(addsuffix .ind, $(NAME))
IDX := $(addsuffix .idx, $(NAME))
AUX := $(addsuffix .aux, $(NAME))

#
#	Output software name
#


#
#	Flags
#
TEXFLAGS = -shell-escape -synctex=1 -output-directory=$(BINDIR) -8bit
INDEXFLAGS = -t $(BINDIR)/$(IST) -o $(BINDIR)/$(IND) -p odd
GLOSFLAGS = -d $(BINDIR)

#
#	Link flags
#

#
#	SymLinks
#

#
#	Files
#
MAINFILE = newtex.tex
GLOSSARIE = glossarie.tex
BIB = bibtex.bib

#
#	Others
#
TEXIN = $(TEMPDIR)

LIBTEXIN = $(HOME)/Bureau/Mes_Documents/Programmation/Latex/mcdpack.sty
LIBTEXOUT = mcdpack.sty

LIBDIRTEXIN = $(HOME)/Bureau/Mes_Documents/Programmation/Latex/mcdpack
LIBDIRTEXOUT = mcdpack

BIB_VALUES = $(shell cat $(OTHDIR)/$(BIB))

#
#	Commands
#
TEXCOMMAND = $(PDFLATEX) $(TEXFLAGS) $(TEX)

#
#	Rules
#
all:
	mkdir -p $(BINDIR)
	reset
	$(TEXCOMMAND)
	$(TEXCOMMAND)
	$(GLOSSTEX) $(GLOSFLAGS) $(NAME)
	$(INDEXTEX) $(INDEXFLAGS) $(BINDIR)/$(IDX)
ifneq ($(BIB_VALUES),)
	bibtex $(BINDIR)/$(AUX)
endif
	$(TEXCOMMAND)
	$(TEXCOMMAND)
	mv build/$(PDF) ./$(PDF)

#
#	Implicit rules
#
.PHONY: pdf clear remake install_dependencies

clear:
	rm -rf $(BINDIR)
	rm -rf *.aux
	rm -rf *.log
	rm -rf *.out
	rm -rf *.pdf
	rm -rf *.synctex.gz
	rm -rf *.toc

remake:
	rm -rf $(BINDIR)/*
	make

pdf:
	evince $(PDF) &

install_dependencies:
	sudo apt install texlive-xetex
	sudo apt install texlive-science

