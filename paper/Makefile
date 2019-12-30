BASEDIR:=$(shell pwd)

BIBFILES:= bibliography.bib
TARGET:= p496-dignoes.pdf techreport.pdf

DEPEND_TEX:=$(wildcard *.tex) $(BIBFILES)

all: $(TARGET)

revision_report.pdf: pvldb.pdf techreport.pdf

define map
	$(foreach a,$(2),$(call $(1),$(a)))
endef

define lrun
	echo "################################################################################"; echo "Building $1..."; echo "################################################################################";
	@$(BASEDIR)/latexrun `basename $1`;
endef

define lclean
	echo "Cleaning $1...";
	@$(BASEDIR)/latexrun --clean-all
endef

define lcleanall
	@$(call map,lclean,$(DIRS))
endef

%.pdf: %.tex $(DEPEND_TEX)
	@$(call lrun, $<)

clean:
	$(call lcleanall)

define cecho
	@tput setaf 2
	@echo $1
	@tput sgr0
endef

proof:
	$(call cecho, "Checking for weasel words...")
	@sh weasel *.tex
	$(call cecho, "Checking for passive voice...")
	@sh passive *.tex
	$(call cecho, "Checking for duplicates (e.g. at end of lines)")
	perl dups *.tex


.PHONY: FORCE clean check-fonts proof
