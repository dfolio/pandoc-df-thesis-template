################################################################################
## Copyright (c) 2018 David Folio
## All rights reserved.
################################################################################
##  License : under CC by license style...
################################################################################
#MAKEFLAGS += --silent
################################################################################
# Output document basename #####################################################
DOC     		:=my_thesis
# Input sources directory ######################################################
MDDIR   		:=_md
# Subdirs ######################################################################
TEMPLATEDIR	:=_layouts
DATADIR 		:=_data
ASSETSDIR		:=assets
CSSDIR  		:=$(ASSETSDIR)/css
SCSSDIR 		:=$(ASSETSDIR)/scss
SASSDIR 		:=_sass
SCSSINCS 		:=$(SASSDIR) node_modules/bootstrap/scss
BIBDIR  		:=$(ASSETSDIR)/bib
FIGDIR  		:=$(ASSETSDIR)/fig
MEDIADIR 		:=$(ASSETSDIR)/media
TEXDIR  		:=_tex
HTMLDIR 		:=_html
XMLDIR 			:=_docbook
EPUBDIR 		:=$(HTMLDIR)
SUBDIRS 		:=$(MDDIR) $(TEXDIR) $(DATADIR) $(FIGDIR) $(HTMLDIR) $(BIBDIR)
# Source files #################################################################
INDIR       :=$(MDDIR)
INFILES_0   := $(shell find $(INDIR) -name '0*'  -type f -prune  -print| sort)
INFILES_1   := $(shell find $(INDIR) -name '[12345678]*'  -type f -prune  -print| sort)
INFILES_9   := $(shell find $(INDIR) -name '9*'  -type f -prune  -print| sort)
INFILES     :=$(INFILES_0) $(INFILES_1) $(INFILES_9)
# Base files ###################################################################
METADATA		:=$(DATADIR)/metadata.yml
VARSDATA		:=$(DATADIR)/variables.yml
BIBFILES    :=$(BIBDIR)/string.bib $(BIBDIR)/thesis-biblio.bib
BIB         :=$(BIBDIR)/bibliography.bib
CSL					:=$(TEMPLATEDIR)/Thesis-ieee-style.csl
GLOSSARIES  :=$(DATADIR)/glossaries.pp
XSL         :=$(TEMPLATEDIR)/xsl/html5.xsl
################################################################################
# Commands #####################################################################
#ifeq (,$(wildcard /usr/local/bin/pandoc))
# 	PANDOC:=/usr/bin/pandoc
# else
# 	PANDOC:=/usr/local/bin/pandoc
# endif
PANDOC		:=/usr/bin/pandoc
PP    		:=/usr/local/bin/pp
#BIBTEX=/usr/bin/bibtex
BIBTEX    :=/usr/bin/biber
TEX2PDF   :=/usr/bin/lualatex -synctex=1 -file-line-error


ECHO_E		:=echo -e
MAKE			:=make
MKDIR			:=mkdir -p
MV				:=mv
NPM 	  	:=/usr/bin/npm
RM				:=rm -rf
RUBY 			:= ruby
SASS 			:=sass
SYNC			:=rsync -r -n -t -p -o -g -v --progress -u -c -l -z -s
TAR   		:=/bin/tar
UNZIP 		:=/usr/bin/unzip -q
XSLTPROC	:=xsltproc

INKSCAPE	:=/usr/bin/inkscape -z
SVGO  		:=/usr/bin/svgo
SCOUR			:=/usr/bin/scour
# Pretty messages output #######################################################
TODAY   =$(shell date +"%F")
NORMAL  ="`tput sgr0`"
DONE    ="`tput sgr0``tput bold``tput setaf 2`*"
RUN     ="`tput sgr0``tput bold``tput setaf 3`**"
BAD     ="`tput sgr0``tput bold``tput setaf 1`"
BUILD   ="`tput sgr0``tput bold``tput setaf 6`"
BRACKET ="`tput sgr0``tput bold``tput setaf 4`"
################################################################################
# PP:  text preprocessor designed for Pandoc ###################################
define PP_FLAGS
	-en -img=$(FIGDIR)
endef
################################################################################
# SASS/CSS  FLAGS ##############################################################
define SASS_FLAGS
	--unix-newlines --precision 8 \
	--default-encoding="utf-8" \
	--load-path="$(SASSDIR)" --load-path="node_modules/"
endef
ifdef $(PROD)
	SASS_OPTIONS += --style compressed
endif
################################################################################
define XSLT_FLAGS
  --nonet --xinclude \
	--path "/usr/share/sgml/docbook/xsl-stylesheets" \
	--encoding utf-8 --timing \
	--stringparam glossary.collection $(GLOSSARIES).xml
endef
################################################################################
# Pandoc options ###############################################################
## Pandoc Global options
define PANDOC_GOPTS
  --metadata-file=$(METADATA) \
	--wrap=preserve \
  --top-level-division=chapter \
  --atx-header \
  --metadata=date:"$(TODAY)"
endef
## Pandoc Bibliography options
define PANDOC_BIB
 	--file-scope\
	--filter pandoc-citeproc --csl=$(CSL) \
	 $(foreach f,$(BIBFILES), --bibliography=$(f))
endef
## Markdown extensions
define PANDOC_MDEXT
yaml_metadata_block+header_attributes+abbreviations+pipe_tables+implicit_figures+definition_lists+fancy_lists+latex_macros
endef
## Pandoc options for Mardown/HTML generations
define PANDOC_MDH_FLAGS
 	--file-scope -F pandoc-crossref
endef
## Options for HTML output
define PANDOC_HTML_FLAGS
	$(PANDOC_BIB) --file-scope --standalone\
	--default-image-extension=svg --mathjax \
  --template=$(TEMPLATEDIR)/template.html5
endef
## Options for XML/DocBook output
define PANDOC_XML_FLAGS
	$(PANDOC_BIB) --file-scope  --standalone\
	--default-image-extension=svg --mathml\
  --template=$(TEMPLATEDIR)/template.docbook5\
  -V glossary=$(wildcard $(GLOSSARIES).xml)
endef
## Options for EPUB output
define PANDOC_EPUB_FLAGS
	$(PANDOC_BIB) --file-scope -standalone\
	--default-image-extension=svg \
  --css=$(CSSDIR)/pandoc_thesis_epub.css \
  --template=$(TEMPLATEDIR)/template.epub3
endef
## Options for DOCX output
define PANDOC_DOCX_FLAGS
	$(PANDOC_BIB) --file-scope \
	--data-dir=$(TEMPLATEDIR) \
	--reference-doc=$(TEMPLATEDIR)/template.docx \
	--default-image-extension=emf
endef
## Options for ODT output
define PANDOC_ODT_FLAGS
	$(PANDOC_BIB) --file-scope \
	--data-dir=$(TEMPLATEDIR) \
	--reference-doc=$(TEMPLATEDIR)/template.odt \
	--default-image-extension=svg
endef
################################################################################
## For LaTex/PDF Outputs
TEXFILES_0  := $(INFILES_0:$(MDDIR)/%.md=$(TEXDIR)/%.tex)
TEXFILES_1  := $(INFILES_1:$(MDDIR)/%.md=$(TEXDIR)/%.tex)
TEXFILES_9  := $(INFILES_9:$(MDDIR)/%.md=$(TEXDIR)/%.tex)
## Pandoc Tex/Bibliography options
define PANDOC_TEX_BIB
 	--file-scope $(foreach f,$(BIBFILES), --bibliography='$f')
endef
## Pandoc options for Mardown/LaTeX generations
define PANDOC_MDT_FLAGS
	-M numberSections=false -F pandoc-crossref  \
	$(PANDOC_TEX_BIB) --default-image-extension=pdf
endef
## Options for LaTeX output
define PANDOC_TEX_FLAGS
  --lua-filter=short-captions.lua  \
  --pdf-engine=lualatex \
	-M numberSections=false --number-sections\
  -V glossary=$(wildcard $(GLOSSARIES).tex) \
	--default-image-extension=pdf \
  --template=$(TEMPLATEDIR)/template.latex \
  $(foreach f,$(TEXFILES_0), --include-before-body=$(f)) \
  $(foreach f,$(TEXFILES_9), --include-after-body=$(f)) \
	$(PANDOC_TEX_BIB)
endef
################################################################################
# LaTeX options ################################################################
ifneq ($(QUIET),)
  TEX2PDF += -interaction=batchmode
  BIBTEX  += -terse
else
  TEX2PDF += -interaction=nonstopmode
endif

## Pattern to check TeX/PDF build
TEX_RERUN     = "(.*undefined references|Rerun to get (.*references|the bars) right)"
TEX_RERUNBIB  = "No file.*\.bbl|Citation.*undefined"
TEX_RERUNGLO  = "(glosstex.*undefined terms|.*glosstex.*(\(re\))?run GlossTeX)"
TEX_BADBOX    = "(([Uu]nder|[Oover])full|\\[hv]box)"

#################################################################################
## Intermediate and target dialects files #######################################
MDH   := $(DOC:%=%.mdh)
MDX   := $(DOC:%=%.mdx)
HTML  := $(DOC:%=%.html)
PDF   := $(DOC:%=%.pdf)
EPUB  := $(DOC:%=%.epub)
XML   := $(DOC:%=%.xml)
DOCX  := $(DOC:%=%.docx)
ODT   := $(DOC:%=%.odt)
MDT   := $(DOC:%=%.mdt)
TEX   := $(TEXDIR)/$(DOC:%=%.tex)
PDF   := $(DOC:%=%.pdf)
## Intermediates files list
### PP-Macros
PP_GLO_HTML =$(DATADIR)/_glo-html.pp
PP_GLO_XML  =$(DATADIR)/_glo-xml.pp
PPFILES     :=  $(wildcard $(DATADIR)/*.pp)
### Generated Markdown files
MDH_FILES_  := $(INFILES:$(MDDIR)/%.md=$(HTMLDIR)/%.mdh)
MDH_FILES   := $(sort $(MDH_FILES_) $(HTMLDIR)/97_glossary.mdh)
MDX_FILES   := $(INFILES:$(MDDIR)/%.md=$(XMLDIR)/%.mdx)
MDT_FILES   := $(INFILES:$(MDDIR)/%.md=$(TEXDIR)/%.mdt)
MDT_FILES_1 := $(INFILES_1:$(MDDIR)/%.md=$(TEXDIR)/%.mdt)
### Generated LaTeX files
TEXFILES    := $(INFILES:$(MDDIR)/%.md=$(TEXDIR)/%.tex)
### SASS/CSS
SCSS        := $(wildcard $(SCSSDIR)/*.scss)
CSS         := $(patsubst $(SCSSDIR)/%.scss,$(CSSDIR)/%.css,$(SCSS))
CSSDEPS     := $(foreach d,  $(SCSSINCS), $(wildcard $(d)/*.scss))
### LaTeX bibifiles
TEX_BIBFILES:=  $(patsubst %,%, \
    $(shell grep -o '\\bibliography{[^}]\+}'  $(TEX) | sed -e 's/^.*{\([^}]*\)}.*/\1/' | sed -e 's/\\_/_/g' -e 's/, */ /g') )
TEX_AUX     := $(TEX:$(TEXDIR)/%.tex=%.aux)
TEX_BBL     := $(TEX:$(TEXDIR)/%.tex=%.bbl)
TEX_LOG     := $(TEX:%.tex=%.log)

### Figures
INFIG0      := `grep "^[^%]*\($(FIGDIR)\/.*\)" $(INFILES) | grep  -o '\($(FIGDIR)\/[^{}\"\.\)]*\)'`
INFIG  		  := $(shell echo $(INFIG0))
FIG_SVG	    := $(INFIG:%=%.svg)
FIG_PDF	    := $(INFIG:%=%.pdf)
FIG_PNG	    := $(INFIG:%=%.png)
FIG_EMF	    := $(INFIG:%=%.emf)
FIGFILES    := $(FIG_SVG) $(FIG_PDF) $(FIG_PNG) $(FIG_EMF)
MEDIAFILES  := $(patsubst $(FIGDIR)/%.svg,$(MEDIADIR)/%.svg,$(FIG_SVG))
################################################################################
# Dependancies
BIB_DEPS  += $(CSL) $(BIBFILES)
MDH_DEPS	+= $(MDH_FILES) $(INFILES) $(PPFILES) $(VARSDATA) $(BIB_DEPS) $(FIG_SVG)
MDX_DEPS	+= $(MDX_FILES) $(INFILES) $(PPFILES) $(VARSDATA) $(BIB_DEPS) $(FIG_SVG)
HTML_DEPS	+= $(MDH) $(MDH_DEPS) $(TEMPLATEDIR)/template.html5\
	$(CSSDIR)/pandoc_thesis.css $(CSSDEPS)
XML_DEPS += $(MDX) $(MDX_DEPS) $(TEMPLATEDIR)/template.docbook5 \
	$(GLOSSARIES).xml $(CSSDIR)/pandoc_thesis_docbook.css $(CSSDEPS)
EPUB_DEPS	+= $(MDH) $(MDH_DEPS) $(TEMPLATEDIR)/template.epub3\
	$(CSSDIR)/pandoc_thesis_epub.css $(CSSDEPS)
DOCX_DEPS	+= $(MDH) $(MDH_DEPS) $(TEMPLATEDIR)/template.docx $(FIG_EMF)
ODT_DEPS	+= $(MDH) $(MDH_DEPS) $(TEMPLATEDIR)/template.odt  $(FIG_SVG)
MDT_DEPS	+= $(MDT_FILES) $(INFILES) $(PPFILES) $(VARSDATA) $(BIB_DEPS)\
 	$(GLOSSARIES).tex
TEX_BIB_DEPS  += $(BIBDEPS) $(BBL)
TEX_DEPS	    += $(MDT_FILES_1) $(INFILES) $(PPFILES) $(VARSDATA) \
  $(BIB_DEPS) $(FIG_SVG) $(FIG_PDF)\
  $(TEMPLATEDIR)/template.latex $(TEMPLATEDIR)/pandoc-thesis.sty\
  $(TEMPLATEDIR)/pandoc-thesis_styles.tex \
	$(TEMPLATEDIR)/pandoc-thesis_macros.tex $(GLOSSARIES).tex\
	$(TEX_BIBDEPS)
#	$(TEXFILES_0) $(TEXFILES_9)
PDF_DEPS	+=  $(TEX) $(TEX_DEPS) $(FIG_SVG) $(FIG_PDF)

# files to clean
CLEAN_FIG_FILES     +=$(FIG_SVG) $(FIG_PDF) $(FIG_PNG) $(FIG_EMF)
CLEAN_CSS_FILES     +=$(CSS)
CLEAN_HTML_FILES		+=$(wildcard $(HTMLDIR)/*.html) \
	$(MDH_FILES) $(MDH) $(PP_GLO_HTML)  $(GLOSSARIES).md
CLEAN_XML_FILES	   	+=$(wildcard $(XMLDIR)/*.xml) \
	$(MDX_FILES) $(MDX) $(PP_GLO_XML) $(GLOSSARIES).xml
CLEAN_TEX_PATTERNS  += *.blg *.brf *.cb *.ind *.idx *.ilg  \
  *.inx  *.toc *.lof *.out *.glx *.gxs *.gxg *.glo \
  *.rel *.ptc *.upa *.upb *.xmpdata
CLEAN_TEX_FILES			+=$(wildcard $(TEXDIR)/*.tex) \
 	$(MDT_FILES) $(MDT) $(GLOSSARIES).tex \
 	$(addprefix $(TEXDIR)/,$(CLEAN_TEX_PATTERNS) )

CLEAN_PATTERNS      += *~ *.bak
CLEAN_FILES         +=$(foreach DIR,$(SUBDIRS),$(addprefix $(DIR)/,$(CLEAN_PATTERNS))) $(BIB)

# files to dist-clean
DISTCLEAN_PATTERNS  :=*.log *.aux *.ind *.gls *.ps *.dvi *.bbl *.toc *.lof *.lot *.ist *.xmpi *.synctex.gz *.bcf *-blx.bib
DISTCLEAN_FILES     :=$(foreach DIR,$(SUBDIRS),$(addprefix $(DIR)/,$(DISTCLEAN_PATTERNS))) \
  $(EPUB) $(HTML) $(XML) $(PDF) \
	$(CLEAN_FIG_FILES) $(CLEAN_CSS_FILES) \
	$(CLEAN_HTML_FILES) $(CLEAN_XML_FILES) $(CLEAN_TEX_FILES)
#	$(MDTEX_FILES) $(MDHTML_FILES) $(MDH_FILES) $(MDT_FILES)

DISTCLEAN_DIRS     := $(HTMLDIR) $(XMLDIR) node_modules $(CSSDIR)
################################################################################
.SUFFIXES:.md .mdh .mdx .mdt\
  .html .xml .epub .pp  \
  .pdf .tex \
  .docx .odt \
  .svg .png .emf \
	.css .scss

.PHONY: html pdf tex epub docbook docx odt mdh mdx mdt \
	glo css fig svg xml-sanitify\
	clean clean-html clean-tex clean-fig clean-css distclean \
	update install dist test
################################################################################
# RULES ########################################################################
all: final
final: xml pdf
watch: watch-xml

## HTML ----------------------
mdh:$(MDH)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'markdown' $(MDH)***$(NORMAL)\n"

$(MDH): $(MDH_DEPS) $(GLOSSARIES).md
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`* [1] Running $(PANDOC) to 'markdown' $@ from $<  ***\n"
	$(PANDOC) -f markdown+$(PANDOC_MDEXT) $(PANDOC_GOPTS)\
	 $(PANDOC_MDH_FLAGS) $(VARSDATA) $(PANDOC_BIB) $(MDH_FILES) \
	 -t markdown+$(PANDOC_MDEXT) -o $(MDH)
	@$(ECHO_E) "$(NORMAL)"

html:$(HTML)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'html5' $(HTML)***$(NORMAL)\n"
watch-html: html
	@./pandoc-watch.sh html $(MDDIR) $(HTML_DEPS)
	@$(ECHO_E) "$(NORMAL)"

$(HTML): $(HTML_DEPS)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`* [2] Running $(PANDOC) to 'html' $@ from $<  ***\n"
	$(PANDOC) -f markdown+$(PANDOC_MDEXT) \
	  $(PANDOC_GOPTS) $(VARSDATA) $(PANDOC_HTML_FLAGS)\
	  $(MDH) -t html5 -o $(HTML)
	@$(ECHO_E) "$(NORMAL)"

## XML/DocBook5 ----------------------
mdx:$(MDX)  $(PP_GLO_XML)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'markdown' $(MDX)***$(NORMAL)\n"

$(MDX): $(MDX_DEPS)  $(PP_GLO_XML)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`* [1] Running $(PANDOC) to 'markdown' $@ from $<  ***\n"
	$(PANDOC) -f markdown+$(PANDOC_MDEXT) \
	  $(PANDOC_GOPTS) $(VARSDATA) $(PANDOC_MDH_FLAGS) \
	  $(MDX_FILES) -t  markdown+$(PANDOC_MDEXT) -o $(MDX)
	@$(ECHO_E) "$(NORMAL)"

xml-sanitify:$(XML) $(XSL)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'xml/DocBook5' $(XML)***\n"
	@sed -e 's/sec:/sec-/g' -e 's/fig:/fig-/g' -e 's/tbl:/tbl-/g' -e 's/eq:/eq-/g' -e 's/[^xml:]id=/ xml:id=/g' < $(XML) > $(XML)_$(TODAY) ;
	@cp $(XML)_$(TODAY) $(XML)
chunk: xml-sanitify
	@$(ECHO_E) "$(BUILD)  * [3] Building HTML output from docbook/XSLT... ";
	$(XSLTPROC) $(XSLT_FLAGS) -o $(XMLDIR)/ $(XSL) $(XML)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'chunked Html' from 'DocBook5' in $(XMLDIR)***$(NORMAL)\n"
#	 | sed -e 's/<abbr/<abbrev/g' | sed -e 's/<\/abbr/<\/abbrev/g' \
docbook: xml-sanitify $(XML) $(XSL)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE $(PANDOC) to DocBook5/xml '$@' ... ";
watch-xml: chunk
	@./pandoc-watch.sh chunk $(MDDIR) $(XML_DEPS)

$(XML): $(XML_DEPS)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`* [2] Running $(PANDOC) to 'xml/DocBook5' $@ from $<  ***\n"
	$(PANDOC) -f markdown+$(PANDOC_MDEXT) $(PANDOC_GOPTS)\
	$(VARSDATA) $(PANDOC_XML_FLAGS) $(MDX) -t docbook5 -o $(XML)
	@$(ECHO_E) "$(NORMAL)"

## EPUB ----------------------
epub:$(EPUB)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'epub3' $(EPUB)***$(NORMAL)\n"
ehtm:$(EPUB)
	@$(RM) $(EPUBDIR); $(UNZIP) -x $(EPUB) -d $(EPUBDIR)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'eHTML' $(EPUB)***$(NORMAL)\n"

watch-ehtm: ehtm
	@./pandoc-watch.sh ehtm $(MDDIR) $(EPUB_DEPS)
	@$(ECHO_E) "$(NORMAL)"

$(EPUB): $(EPUB_DEPS)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`* [2] Running $(PANDOC) to 'epub' $@ from $<  ***\n"
	$(PANDOC) $(PANDOC_GOPTS) $(PANDOC_EPUB_FLAGS) \
	-f markdown+$(PANDOC_MDEXT) $(VARSDATA) $(MDH)\
	-t epub3 -o $(EPUB)
	@$(ECHO_E) "$(NORMAL)"

## DOCX ----------------------
docx:$(DOCX)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'MS doc' $(DOCX)***$(NORMAL)\n"

$(DOCX): $(DOCX_DEPS)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`* [2] Running $(PANDOC) to 'MS doc' $@ from $<  ***\n"
	$(PANDOC) $(PANDOC_GOPTS) $(PANDOC_DOCX_FLAGS)\
	 -f markdown+$(PANDOC_MDEXT) $(VARSDATA) $(MDH)\
	  -t docx -o $(DOCX)
	@$(ECHO_E) "$(NORMAL)"

## ODT ----------------------
odt:$(ODT)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'OO odt' $(ODT)***$(NORMAL)\n"

$(ODT): $(ODT_DEPS)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`* [2] Running $(PANDOC) to 'OO odt' $@ from $<  ***\n"
	$(PANDOC) $(PANDOC_GOPTS) $(PANDOC_ODT_FLAGS) \
	  $(VARSDATA) $(MDH) -t odt -o $(ODT)
	@$(ECHO_E) "$(NORMAL)"

## LaTeX  ----------------------
mdt:$(MDT) $(MDT_DEPS)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'markdown' $(MDT)***$(NORMAL)\n"
$(MDT): $(MDT_DEPS) $(VARSDATA)
	@$(ECHO_E) "*** [B] Running $(PANDOC) to 'Markdown/(La)TeX' $@ from $<  ***\n"
	$(PANDOC) $(PANDOC_GOPTS) $(PANDOC_MDT_FLAGS)\
	  -f markdown_phpextra+$(PANDOC_MDEXT) $(VARSDATA) $(MDT_FILES)\
	  -t  markdown_phpextra+$(PANDOC_MDEXT) -o $(MDT)
		@$(ECHO_E) "$(NORMAL)"

tex:$(TEX)
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  $(PANDOC) to 'TeX' $(TEX) ***$(NORMAL)\n"

$(TEX): $(TEXFILES_0) $(TEXFILES_9) $(TEX_DEPS)
	@$(ECHO_E) "$(BUILD)  * [3] Build with $(PANDOC) to 'TeX' $@   ***\n"
	$(PANDOC) $(PANDOC_GOPTS) $(VARSDATA)  $(PANDOC_TEX_FLAGS)\
	  $(MDT_FILES_1) -t latex -o $(TEX)
		@$(ECHO_E) "$(NORMAL)"
pdf: $(PDF)
		@$(ECHO_E) "$(NORMAL)"

watch-pdf: pdf
	./pandoc-watch.sh pdf $(MDDIR) $(PDF_DEPS)
	@$(ECHO_E) "$(NORMAL)"

$(PDF): $(PDF_DEPS)
	@$(ECHO_E) "$(BUILD)`date +"* %F %T"`* [3a] Building $(PDF) ... ";
	(cd $(TEXDIR) && $(TEX2PDF) $(TEX:$(TEXDIR)/%=%) )
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`*  [3a] First pass pdf $(PDF) ***$(NORMAL)\n"
	@egrep -c $(TEX_RERUNBIB) $(TEX_LOG) >/dev/null && \
	 ( $(ECHO_E) "\n\n***\n*** Rebuild Bibliography...\n" &&\
	  $(MAKE) bib &&  (cd $(TEXDIR) && $(TEX2PDF) $(TEX:$(TEXDIR)/%=%) ) ) ; true
	@egrep $(TEX_RERUN) $(TEX_LOG) >/dev/null &&  (cd $(TEXDIR) && $(TEX2PDF) $(TEX:$(TEXDIR)/%=%) ) ; true
#	$(RM) $@
	@$(MV) $(TEXDIR)/$(PDF) .
	@$(ECHO_E) "$(NORMAL)"

%.aux:%.tex $(TEX_DEPS)
	@$(ECHO_E) "*** [0] Missing $(TEX_AUX) ???  $* from $@ [$<] \n"
	@$(TEX2PDF) $<

%.bbl: %.aux $(TEX_DEPS) $(BIB_DEPS)
	@$(ECHO_E) "*** [0] Running $(BIBTEX) on $* from $@ [$<   $(basename $<)]..."
	$(BIBTEX)   $(basename $<)

bib: $(TEX_BIB_DEPS)
	$(BIBTEX)  $(basename $(TEX))

biblio:$(BIB)
$(BIB): $(BIBFILES)
	@$(ECHO_E) "$(BUILD)  * [1] Merge all bibliography in  $(BIB) ... ";
	@cat $(BIBFILES) > $(BIB)
	@$(ECHO_E) "$(NORMAL)"

################################################################################
# Intermediate HTML rules
$(HTMLDIR)/%.mdh:$(MDDIR)/%.md $(DATADIR)/html.pp $(DATADIR)/macros.pp $(PP_GLO_HTML)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(PANDOC) to 'markdown' $@ from $<  ***$(NORMAL)\n"
	@$(MKDIR) $(HTMLDIR)
	$(PP) $(PP_FLAGS) -DHTML=1 -import=$(DATADIR)/macros.pp -import=$(PP_GLO_HTML) $< | \
	  $(PANDOC) -f markdown+$(PANDOC_MDEXT) $(PANDOC_GOPTS) \
	  -t  markdown+$(PANDOC_MDEXT) -o "$@"
	@sed  -e 's/\]\s*\[@/; @/g' < $@> $@_2 && mv $@_2 $@
	@$(ECHO_E) "$(NORMAL)"

# XML rules
$(XMLDIR)/%.mdx:$(MDDIR)/%.md $(DATADIR)/xml.pp $(GLOSSARIES).xml $(PP_GLO_XML)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(PANDOC) to 'markdown' $@ from $<  ***$(NORMAL)\n"
	@$(MKDIR) $(XMLDIR)
	$(PP) $(PP_FLAGS) -DXML=1 -import=$(DATADIR)/macros.pp -import=$(PP_GLO_XML) $< | \
	  $(PANDOC) -f markdown+$(PANDOC_MDEXT) $(PANDOC_GOPTS) \
	  -t markdown+$(PANDOC_MDEXT) -o "$@"
	@sed  -e 's/\]\s*\[@/; @/g' < $@> $@_2 && mv $@_2 $@
	@$(ECHO_E) "$(NORMAL)"

#  Intermediate TEX rules
%.tex:%.mdt $(TEX_DEPS)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(PANDOC) to 'Markdown/(La)TeX' $@ from $<  ***\n"
	$(PANDOC) -f  markdown+$(PANDOC_MDEXT) $(PANDOC_GOPTS) \
	  $(PANDOC_MDT_FLAGS) $< -t latex -o "$@"
	@sed  -e 's/}\s*\\cite{/,/g' -e 's/}\s*\\cref{/,/g'  < $@> $@_2 && mv $@_2 $@
	@$(ECHO_E) "$(NORMAL)"


$(TEXDIR)/%.mdt:$(MDDIR)/%.md $(DATADIR)/latex.pp $(DATADIR)/macros.pp
	@$(ECHO_E) "$(BUILD)`date +"* %F %T"`*  [A] Build $(PANDOC) to 'Markdown/(La)TeX' $@ from $<  ***\n"
	$(PP) $(PP_FLAGS) -DLATEX=1 -import=$(DATADIR)/macros.pp $< | \
	  $(PANDOC) -f  markdown+$(PANDOC_MDEXT) $(PANDOC_GOPTS) \
	  $(PANDOC_MDT_FLAGS) -t markdown+$(PANDOC_MDEXT) -o "$@"
	@sed  -e 's/}\s*\\cite{/,/g' -e 's/}\s*\\cref{/,/g'  < $@> $@_2 && mv $@_2 $@
	@$(ECHO_E) "$(NORMAL)"

../$(TEXDIR)/%.mdt:
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [B] Running $(PANDOC) to '(La)TeX' $@ from $<  ***$(NORMAL)\n"
	@$(MAKE) $(TEXDIR)/%.mdt
	@$(ECHO_E) "$(NORMAL)"


################################################################################
#  Intermediate Glossaries rules
glo: $(GLOSSARIES).md $(GLOSSARIES).xml $(GLOSSARIES).tex $(HTMLDIR)/97_glossary.mdh
	@$(ECHO_E) "$(DONE)`date +"* %F %T"`* [2] DONE  make glossary ***$(NORMAL)\n"

$(GLOSSARIES).md:$(GLOSSARIES) $(DATADIR)/html.pp $(DATADIR)/macros.pp
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(PP) to build HTMLglossary  $@ from $<  ***$(NORMAL)\n"
	$(PP) $(PP_FLAGS) -DHTML=1 -import=$(DATADIR)/macros.pp -D_PP_GLO_TMP=$(PP_GLO_HTML) $(GLOSSARIES) > $(GLOSSARIES).md
$(HTMLDIR)/97_glossary.mdh: $(GLOSSARIES).md $(PP_GLO_HTML)
	@cp $(GLOSSARIES).md $(HTMLDIR)/97_glossary.mdh

$(PP_GLO_HTML): $(GLOSSARIES) $(DATADIR)/macros.pp
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(PP) to build glossary  $@ from $<  ***$(NORMAL)\n"
	$(PP) $(PP_FLAGS) -DHTML=1 -import=$(DATADIR)/macros.pp -D_PP_GLO_TMP=$(PP_GLO_HTML) $(GLOSSARIES) > $(GLOSSARIES).md

$(GLOSSARIES).xml:$(GLOSSARIES) $(DATADIR)/xml.pp $(DATADIR)/macros.pp $(PP_GLO_XML)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(PP) to build glossary  $@ from $<  ***$(NORMAL)\n"
	$(PP) $(PP_FLAGS) -DXML=1 -import=$(DATADIR)/xml.pp -D_PP_GLO_TMP=$(PP_GLO_XML) $(GLOSSARIES) > $(GLOSSARIES).xml

$(PP_GLO_XML): $(GLOSSARIES) $(DATADIR)/macros.pp
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(PP) to build glossary  $@ from $<  ***$(NORMAL)\n"
	$(PP) $(PP_FLAGS) -DXML=1 -import=$(DATADIR)/xml.pp -D_PP_GLO_TMP=$(PP_GLO_XML) $(GLOSSARIES) > $(GLOSSARIES).xml

$(GLOSSARIES).tex:$(GLOSSARIES) $(DATADIR)/latex.pp $(DATADIR)/macros.pp
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(PP) to build glossary  $@ from $<  ***$(NORMAL)\n"
	$(PP) $(PP_FLAGS) -DLATEX=1 -import=$(DATADIR)/macros.pp $(GLOSSARIES) > $(GLOSSARIES).tex

################################################################################
#  Intermediate CSS rules
css: $(CSS)
$(CSSDIR)/%.css: $(SCSSDIR)/%.scss $(CSSDEPS)
	@$(ECHO_E) "$(RUN)`date +"* %F %T"`*  [A] Running $(SASS) to 'CSS' $@ from $<  ***\n"
	@$(MKDIR) $(CSSDIR)
	$(SASS) $(SASS_FLAGS) $< $@
	@$(ECHO_E) "$(NORMAL)"

#@echo SASS '' $(notdir $@);
watch-css: $(CSS)
	./pandoc-watch.sh css $(MDDIR) $(SCSS) $(wildcard _sass/*.scss)
	@$(ECHO_E) "$(NORMAL)"

################################################################################
#  Intermediate FIG rules
fig:$(FIGFILES)
$(FIGDIR)/%.pdf:$(MEDIADIR)/%.svg
	@$(ECHO_E) "*** [A] Running $(INKSCAPE) to 'pdf' $@ from $<  ***$(NORMAL)\n"
	@$(INKSCAPE)	--export-area-page --export-pdf=$@ $<

$(FIGDIR)/%.png:$(MEDIADIR)/%.svg
	@$(ECHO_E) "*** [A] Running $(INKSCAPE) to 'png' $@ from $<  ***$(NORMAL)\n"
	@$(INKSCAPE)	--export-area-page --export-png=$@ $<

$(FIGDIR)/%.emf:$(MEDIADIR)/%.svg
	@$(ECHO_E) "*** [A] Running $(INKSCAPE) to 'emf' $@ from $<  ***$(NORMAL)\n"
	@$(INKSCAPE)	--export-area-page --export-emf=$@ $<

svg:$(FIG_SVG)
$(FIGDIR)/%.svg:$(MEDIADIR)/%.svg
	@$(ECHO_E) "*** [A] Running $(INKSCAPE) to 'svg' $@ from $<  ***$(NORMAL)\n"
	@$(INKSCAPE)	 --vacuum-defs --export-area-page --export-plain-svg=$@ $<
	@$(SVGO) --enable={cleanupIDs,collapseGroups,removeUnusedNS,removeUselessStrokeAndFill,removeUselessDefs,removeComments,removeMetadata,removeEmptyAttrs,removeEmptyContainers} $@
	$(SCOUR)  --enable-viewboxing --enable-id-stripping \
		--enable-comment-stripping --shorten-ids --indent=none \
		-i $@ -o $@o && cp $@o $@
#
################################################################################
# This pseudo-target produces the distribution archives.
dist: distclean
	cd ../ && $(TAR) czf $(TODAY)_$(DOC).tar.gz  pandoc
# clean files
clean-all: clean-html clean-tex clean-css clean-fig clean
	@$(ECHO_E) "***  clean (all) project \n"
clean:
	@$(ECHO_E) "***  clean unnecessary documents\n"
	$(RM)  $(CLEAN_FILES)

clean-html:
	@$(ECHO_E) "***  clean HTML\n"
	$(RM)  $(CLEAN_HTML_FILES)
clean-tex:
	@$(ECHO_E) "***  clean TEX\n"
	$(RM)  $(CLEAN_TEX_FILES)
clean-xml:
	@$(ECHO_E) "***  clean XML\n"
	$(RM)  $(CLEAN_XML_FILES) $(XMLDIR)/*

clean-css:
	@$(ECHO_E) "***  clean CSS\n"
	$(RM)  $(CLEAN_CSS_FILES)
clean-fig:
	@$(ECHO_E) "***  clean FIG\n"
	$(RM)  $(CLEAN_FIG_FILES) $(FIGDIR)/*.svgo


# dist-clean files
distclean: clean-all
	@$(ECHO_E) "***  distclean project\n"
	$(RM)  $(DISTCLEAN_FILES) $(DISTCLEAN_DIRS)
	@$(MAKE) -C $(TEXDIR) distclean

################################################################################
update:
	@$(SU) $(NPM) update -g

info:
	@$(ECHO_E) "TEX:$(basename $(TEX)) "
	@$(ECHO_E) "TEX: '$(MDT_FILES_1)'  "
