DEBUG = no

#
#	Softwares
#
PDFLATEX = xelatex
INDEXTEX = makeindex
GLOSSTEX = makeglossaries
BIBLITEX = bibtex

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
TEXFLAGSs = -shell-escape -synctex=1 -output-directory=$(BINDIR) -8bit

ifeq ($(DEBUG), yes)
TEXFLAGS = $(TEXFLAGSs) -interaction scrollmode
else
TEXFLAGS = $(TEXFLAGSs) -interaction batchmode
endif

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

LINE = @echo "\n------------------------------------------------------------------------"

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
	$(LINE)
	$(TEXCOMMAND)
	$(LINE)
	$(GLOSSTEX) $(GLOSFLAGS) $(NAME)
	$(INDEXTEX) $(INDEXFLAGS) $(BINDIR)/$(IDX)
ifneq ($(BIB_VALUES),)
	$(BIBLITEX) $(BINDIR)/$(AUX)
endif
	$(LINE)
	$(TEXCOMMAND)
	$(LINE)
	$(TEXCOMMAND)
	mv build/$(PDF) ./$(PDF)

#
#	Implicit rules
#
.PHONY: pdf clear remake install_dependencies get sync

clear:
	rm -rf $(BINDIR)
	rm -rf *.aux
	rm -rf *.log
	rm -rf *.out
	rm -rf *.pdf
	rm -rf *.synctex.gz
	rm -rf *.toc

remake: clear
	rm -rf $(BINDIR)/*
	make

pdf:
	evince $(PDF) &

install_dependencies:
	sudo apt install texlive-binaries texlive-latex-extra texlive-xetex
	sudo apt install findutils texlive-base texlive-bibtex-extra texlive-binaries texlive-extra-utils texlive-fonts-recommended texlive-lang-english texlive-lang-european texlive-lang-french texlive-lang-other texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex texlive-pictures texlive-plain-generic texlive-pstricks texlive-science texlive-xetex wfrench xindy

get:
	git pull
	make remake

GIT_COMMIT_SAMPLE = makefile auto update
GIT_COMMIT = $(GIT_COMMIT_SAMPLE)

sync: get
ifeq ($(GIT_COMMIT),$(GIT_COMMIT_SAMPLE))
	@echo "You can change the default commit message by defining GIT_COMMIT"
endif
	git add .
	git commit -m "$(GIT_COMMIT)"
	git push

