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
TXT := $(addsuffix .txt, $(NAME))
HTML := $(addsuffix .html, $(NAME))

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
BEF_ARGS = 
AFT_ARGS = 

#
#	Commands
#
TEXCOMMAND = $(PDFLATEX) $(TEXFLAGS) $(BEF_ARGS)$(TEX)$(AFT_ARGS)

#
#	Rules
#
all:
	mkdir -p $(BINDIR)
	reset
	make $(PDF)

$(PDF): $(BINDIR)/$(PDF)
	mv $(BINDIR)/$(PDF) ./$(PDF)

$(BINDIR)/$(PDF): $(TEX) $(OTHDIR)/$(BIB) $(OTHDIR)/$(GLOSSARIE)
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

$(BINDIR)/$(TXT): clear
	make all BEF_ARGS="\"\providecommand\toplaintext{true}\input{" AFT_ARGS="}\""
	pdftotext $(PDF) $(BINDIR)/$(TXT)
	tr '\n' ' ' < $(BINDIR)/$(TXT) > $(BINDIR)/$(TXT).tmp
	mv $(BINDIR)/$(TXT).tmp $(BINDIR)/$(TXT)

$(BINDIR)/$(HTML): clear
	make all BEF_ARGS="\"\providecommand\toplaintext{true}\input{" AFT_ARGS="}\""
	pdftohtml $(PDF) -stdout > $(BINDIR)/$(HTML)

#
#	Implicit rules
#
.PHONY: pdf clear remake debug get_error txt html install_dependencies get sync

clear:
	rm -rf $(BINDIR)
	rm -rf *.aux
	rm -rf *.log
	rm -rf *.out
	rm -rf *.pdf
	rm -rf *.synctex.gz
	rm -rf *.toc

remake: clear
	make

pdf:
	evince $(PDF) &

debug: clear
	make all DEBUG=yes

get_error:
	make debug | grep "^!"

txt: $(BINDIR)/$(TXT)

html: $(BINDIR)/$(HTML)

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

