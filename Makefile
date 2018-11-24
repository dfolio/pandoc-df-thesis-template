################################################################################
## Copyright (c) 2018 David Folio
## All rights reserved.
################################################################################
##  License : under CC by license style...
################################################################################

.DEFAULT_GOAL	?= all
# Note that the user-global version is imported *after* the source directory,
# so that you can use stuff like ?= to get proper override behavior.
-include Makefile.ini

################################################################################
# SIMPLE CONFIGURATION #########################################################

#Select the HTML format 
BUILD_HTML_FORMAT   ?= htmlmulti
#BUILD_HTML_FORMAT   ?= htmlsimple
#Select the prefered build strategy
#BUILD_TEX_STRATEGY  ?= pdflatex
BUILD_TEX_STRATEGY  ?= lualatex
#BUILD_TEX_STRATEGY  ?= xelatex
BUILD_BIB_STRATEGY  ?= biblatex
#BUILD_BIB_STRATEGY  ?= bibtex

# Select the default targets
# Values any of:  pdf, html, epub, odt, docx, xml/DocBook
BUILD_DEFAULT_TARGETS       ?= html pdf

# Specify the main output document basename 
# Note that this can be changed on the commandline or in Makefile.ini:
#
# Command line:
#   make MAINDOC=myThesis
#
MAIN_DOC_BASENAME ?=my_thesis

# Document main language
# TODO: nowaday only 'en' (english) supported
MAINLANG    ?=en

# Define the top level division of the documentation
# Obviously for a thesis this should be chapter (or eventually to part)
# (whereas for article it should set to section)
# TODO: part level support
TOP_LEVEL_DIVISION ?=  chapter

# (Un)comment to (dis)enable VERBOSE
# This should be enabled mainly for debugging purpose as many outputs will be 
# echoed.
# Note any value enable the VERBOSE mode
#VERBOSE     ?= 1

# If set to something, will cause temporary files to not be deleted immediately
KEEP_TEMP	  ?=

# Directory where the original (Markdow) sources files are looked for.
# By default Markdown (MD) sources are assumed defined by MDDIR
#
# Note that this can be changed on the commandline or in Makefile.ini:
#
# Command line:
#   make INDIR=$HOME/Inputs
# 
# Also, you can specify a relative directory (relative to the Makefile):
#   make INDIR=in myfile.pdf
#
# Or, you can use Makefile.ini:
#
#   INDIR := $(HOME)/in
MDDIR   		?=_md
INDIR       ?=$(MDDIR)

# Directory into which we place "binaries" if it exists.
# Note that this can be changed on the commandline or in Makefile.ini:
#
# Command line:
#   make OUTDIR=$HOME/pdfs myfile.pdf
#
# Also, you can specify a relative directory (relative to the Makefile):
#   make OUTDIR=html myfile.pdf
#
# Or, you can use Makefile.ini:
#
#   OUTDIR  := $(HOME)/bin_out
#
OUTDIR	    ?= build

# Subdirs 
# where all templates are stored
TEMPLATEDIR	?=_layouts
TEMPLATEJEKYLLDIR   ?= $(TEMPLATEDIR)/jekyll
# data/variables/macro/glossaries should be placed in DATADIR
DATADIR 		?=_data
# various stuff can be placed ASSETSDIR such as bib, media, fonts...
# but, "publishable" (eg. in case of html outputs) files must be placed in "$(OUTDIR)/$(ASSETSDIR)"
# Some subdir of the initial ASSETSDIR could be copied   "$(OUTDIR)/$(ASSETSDIR)"
ASSETSDIR		?=assets
OUT_ASSETSDIR		?=$(OUTDIR)/$(ASSETSDIR)
BIBDIR  		?=$(ASSETSDIR)/bib
OUT_BIBDIR  		?=$(OUT_ASSETSDIR)/bib
MEDIADIR 		?=$(ASSETSDIR)/media
FIGDIR  		?=$(ASSETSDIR)/fig
OUT_FIGDIR	?=$(OUT_ASSETSDIR)/fig
# Output directories for intermediates files 
MDHDIR   		?=$(OUTDIR)/mdh
MDXDIR   		?=$(OUTDIR)/mdx
MDTDIR   		?=$(OUTDIR)/mdt
# Output directories for generated files 
TEXDIR  		?=$(MDTDIR)
HTMLDIR 		?=$(OUTDIR)
HTMLMULTIDIR?=$(OUTDIR)/html
XMLDIR 			?=$(OUTDIR)
CHUNKDIR 		?=$(HTMLMULTIDIR)
# SASS/CSS dirs 
CSSDIR  		?=$(OUTDIR)/$(ASSETSDIR)/css
SCSSDIR 		?=$(ASSETSDIR)/scss
SASSDIR 		?=_sass
# created by npm (nodejs)
NODEDIR     ?=node_modules
SCSSINCS 		?=$(SASSDIR) $(NODEDIR)/bootstrap/scss

prepare_targets+=$(NODEDIR)/bootstrap

# END SIMPLE CONFIGURATION
################################################################################

################################################################################
# ADVANCED CONFIGURATION

# Sets LC_ALL=C, by default, so that the locale-aware tools, like sort, be
# immune to changes to the locale in the user environment.
export LC_ALL ?= C

# Sources files patterns that will be searched in INDIR
# This is for automatically definition of the sources files.
# Note: the files extension are not checked at this level. It is assumed that the
# sources files are in Markdown format. 
#
# You may define manually bellow the different sources files
sources_frontmatter_pattern ?= 0*
sources_mainmatter_pattern  ?= [12345678]*
sources_backmatter_pattern  ?= 9*

# Base files
## Edit the METADATA to customize pandoc
METADATA		?=$(DATADIR)/metadata.yml
## Edit the VARSDATA to customize pandoc
VARSDATA		?=$(DATADIR)/variables.yml
## Put here all the necessary bibliography files
BIBFILES    ?=$(BIBDIR)/string.bib $(BIBDIR)/thesis-biblio.bib
## Where all bibliographies are merged
BIB         ?=$(OUT_BIBDIR)/bibliography.bib
CSL					?=$(TEMPLATEDIR)/Thesis-ieee-style.csl
XSL         ?=$(TEMPLATEDIR)/xsl/html5.xsl

# preprocessor macros
PP_MACROS   ?=$(DATADIR)/macros.pp
# HTML preprocessor macros
PP_HTML_MACROS   ?=$(DATADIR)/html.pp
# XML preprocessor macros
PP_XML_MACROS   ?=$(DATADIR)/xml.pp
# TeX preprocessor macros
PP_TEX_MACROS    ?=$(DATADIR)/latex.pp

### PP-Macros

## Glossaries files formatted with pp preprocessor
GLOSSARIES      ?=$(DATADIR)/glossaries.pp

## The generated glossaries for HTML outputs
## Set the digit to position properly the glossaries in either the front matter
## or in the back matter (default: 97)  
GLOSSARIES_MDH  ?=$(MDHDIR)/97_glossaries.mdh
GLOSSARIES_XML  ?=$(XMLDIR)/glossaries.xml
GLOSSARIES_TEX  ?=$(TEXDIR)/glossaries.tex

PP_GLO_HTML     ?=$(HTMLDIR)/_glo-html.pp
PP_GLO_XML      ?=$(XMLDIR)/_glo-xml.pp

# END ADVANCED CONFIGURATION
#############################################################################

#############################################################################
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#############################################################################
#                                                                           #
#                       FOR ADVANCED USERS ONLY                             #
#                                                                           #
#############################################################################
# # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # # #
#############################################################################

# IMPORTANT!
#
# When adding to the following list, do not introduce any blank lines.  The
# list is extracted for documentation using sed and is terminated by a blank
# line.
#
# EXTERNAL PROGRAMS:
# = ESSENTIAL PROGRAMS
# == Basic Shell Utilities
CAT       ?= cat
CP        ?= cp -f
DIFF      ?= diff
DATE      ?= date
ECHO      ?= echo
EGREP     ?= egrep
FIND      ?= find
GREP      ?= grep
MKDIR			?= mkdir -p
MKTEMP		?= mktemp
MV        ?= mv -f
SED       ?= sed
SORT		  ?= sort
TOUCH		  ?= touch
UNIQ		  ?= uniq
WHICH		  ?= which
# == Pandoc Utilities
PANDOC    ?=pandoc
PP        ?=pp
# == LaTeX (tetex-provided)
LATEX     ?= latex
PDFLATEX  ?= pdflatex --shell-escape
XELATEX   ?= xelatex --shell-escape
LUALATEX  ?= lualatex --shell-escape
# == Makefile Color Output
TPUT      ?= tput
# == Figures Generation
ASYMPTOTE ?= asy
CONVERT   ?= convert      # ImageMagick
DOT       ?= dot          # GraphViz
DOT2TEX   ?= dot2tex      # dot2tex - add options (not -o) as needed
GNUPLOT   ?= gnuplot      # GNUplot
INKSCAPE  ?= inkscape -z  # Inkscape (svg support)
POTRACE   ?= potrace      # Inkscape (svg support)
SVGO  		?= svgo
SCOUR			?= scour
# == Usefull external program 
GUNZIP    ?= gunzip       # GZipped file
NPM 	  	?= npm
RUBY 			?= ruby
GEM       ?= gem
BUNDLE    ?= bundle
JEKYLL   ?= jekyll
SASS 			?= $(NODEDIR)/.bin/sass
RSYNC			?= rsync 
TAR       ?= tar          # To make archive
UNZIP 		?= unzip -q
XSLTPROC	?= xsltproc

# This ensures that even when echo is a shell builtin, we still use the binary
# (the builtin doesn't always understand -n)
FIXED_ECHO	:= $(if $(findstring -n,$(shell $(ECHO) -n)),$(shell which echo),$(ECHO))
ECHO	      := $(if $(FIXED_ECHO),$(FIXED_ECHO),$(ECHO))

TODAY       := $(shell $(DATE) +"%F")

################################################################################
# Default FLAGS
#

# Default image extension. 
# Suitable value can be svg (prefered) or png
default_image_extension ?= svg

RSYNC_FLAGS   ?=-r -t -p -o -g -l -c -z -u -s -a

# PP:  text preprocessor designed for Pandoc 
PP_FLAGS      ?= -$(MAINLANG) -img=$(FIGDIR)

# Pandoc options 
# Note: it will be more convenient to define pandoc option if its possible from
# the METADATA file. 
# Any defined options below override the values from METADATA file.
#

ifdef TOP_LEVEL_DIVISION
top_lvl_div ?=--top-level-division=chapter
endif

## Pandoc Global options
PANDOC_FLAGS    ?=\
  --metadata-file=$(METADATA) \
	--wrap=preserve \
  $(top_lvl_div) \
  --atx-header \
  --metadata=date:"$(TODAY)"
  
## Pandoc Markdown extensions
PANDOC_MDEXT      ?=+raw_html+raw_tex+abbreviations+yaml_metadata_block+header_attributes+definition_lists

## Pandoc  Bibliography options managed with pandoc-citeproc
PANDOC_CITEPROC_FLAGS  ?= --file-scope\
	--filter pandoc-citeproc --csl=$(CSL) \
	 $(foreach f,$(BIBFILES), --bibliography=$(f))

## Pandoc options for Mardown/HTML generations
PANDOC_MDH_FLAGS  ?= 	--file-scope -F pandoc-crossref

## Options for HTML output
## Note CSS files must be defined in VARSDATA file not here
PANDOC_HTML_FLAGS ?= $(PANDOC_MDH_FLAGS) \
  $(PANDOC_CITEPROC_FLAGS) --file-scope --standalone\
	--default-image-extension=$(default_image_extension) --mathjax \
  --template=$(TEMPLATEDIR)/template.html5
  
## Options for XML/DocBook output
PANDOC_XML_FLAGS ?= $(PANDOC_MDH_FLAGS) 	$(PANDOC_CITEPROC_FLAGS)\
	--default-image-extension=$(default_image_extension) --mathml\
  --template=$(TEMPLATEDIR)/template.docbook5
  
## Options for EPUB output
PANDOC_EPUB_FLAGS ?=  $(PANDOC_MDH_FLAGS) $(PANDOC_CITEPROC_FLAGS)\
	--default-image-extension=$(default_image_extension) \
  --css=$(CSSDIR)/pandoc_thesis_epub.css \
  --template=$(TEMPLATEDIR)/template.epub3
  
## Options for DOCX output
PANDOC_DOCX_FLAGS ?= $(PANDOC_MDH_FLAGS) $(PANDOC_CITEPROC_FLAGS)\
	--data-dir=$(TEMPLATEDIR) \
	--reference-doc=$(TEMPLATEDIR)/template.docx \
	--default-image-extension=emf
	
## Options for ODT output
PANDOC_ODT_FLAGS  ?= $(PANDOC_MDH_FLAGS) $(PANDOC_CITEPROC_FLAGS)\
	--data-dir=$(TEMPLATEDIR) \
	--reference-doc=$(TEMPLATEDIR)/template.odt \
	--default-image-extension=png

## Pandoc options for Mardown/LaTeX generations
PANDOC_MDT_FLAGS  ?= -M numberSections=false -F pandoc-crossref  \
	$(PANDOC_TEX_BIB) --default-image-extension=pdf

## Pandoc Tex/Bibliography options
PANDOC_TEX_BIB_FLAGS  ?= --file-scope \
  $(foreach f,$(BIBFILES), --bibliography='$f')

## Options for LaTeX output
PANDOC_TEX_FLAGS  ?= --file-scope -standalone\
  --pdf-engine=$(BUILD_TEX_STRATEGY) \
	-M numberSections=false --number-sections\
	--default-image-extension=pdf \
  --template=$(TEMPLATEDIR)/template.latex \
	$(PANDOC_TEX_BIB_FLAGS)
	
## LaTex/pdfLaTeX/xeLateX/luaLaTeX flag
TEXFLAGS      ?= -synctex=1 --shell-escape

SASS_FLAGS    ?= --load-path="$(SASSDIR)" --load-path="$(NODEDIR)"

XSLT_FLAGS    ?= --nonet --xinclude \
	--path "/usr/share/sgml/docbook/xsl-stylesheets" \
	--encoding utf-8 --timing \
	
# GNUplot
define determine-gnuplot-output-extension
$(if $(shell $(WHICH) $(GNUPLOT) 2>/dev/null),
     $(if $(findstring unknown or ambiguous, $(shell $(GNUPLOT) -e "set terminal pdf" 2>&1)),
	  eps, pdf),
     none)
endef
GNUPLOT_OUTPUT_EXTENSION	?= $(strip $(call determine-gnuplot-output-extension))

# The most likely to be source but not finished product go first
graphic_source_extensions	:= \
				   gpi \
				   xvg \
				   svg \
				   dot \
				   asy \
				   eps.gz
				   
# Turn on final version of the document
ifdef PROD
undefine VERBOSE
undefine DRAFT
SASS_FLAGS += --style=compressed
endif
# Manage quiet/verbose mode 
ifndef VERBOSE
QUIET	:= @
endif

ifneq ($(QUIET),)
MAKEFLAGS   += --silent
else
VERBOSE     ?= 1
endif
ifdef VERBOSE
TEXFLAGS    += -interaction=nonstopmode
PANDOC_FLAGS+= --verbose
RSYNC_FLAGS += --verbose -h --progress
else
TEXFLAGS    += -interaction=batchmode -file-line-error
BIBTEX      += -terse
PANDOC_FLAGS+= --quiet
SASS_FLAGS  += --quiet
RSYNC_FLAGS += --quiet
endif

# Turn on shell debugging with SHELL_DEBUG=1
# (EVERYTHING is echoed, even $(shell ...) invocations)
ifdef SHELL_DEBUG
SHELL	+= -x
endif

# Get the name of this makefile (always right in 3.80, often right in 3.79)
# This is only really used for documentation, so it isn't too serious.
ifdef MAKEFILE_LIST
this_file	:= $(firstword $(MAKEFILE_LIST))
else
this_file	:= $(wildcard GNUmakefile makefile Makefile)
endif

#
# EXTERNAL PROGRAM DOCUMENTATION SCRIPT
#

# $(call output-all-programs,[<output file>])
define output-all-programs
	[ -f '$(this_file)' ] && \
	$(SED) \
		-e '/^[[:space:]]*#[[:space:]]*EXTERNAL PROGRAMS:/,/^$$/!d' \
		-e '/EXTERNAL PROGRAMS/d' \
		-e '/^$$/d' \
		-e '/^[[:space:]]*#/i\ '\
		-e 's/^[[:space:]]*#[[:space:]][^=]*//' \
		$(this_file) $(if $1,> '$1',) || \
	$(ECHO) "Cannot determine the name of this makefile."
endef
# If they misspell gray, it should still work.
GRAY	?= $(call get-default,$(GREY),)

###############################################################################
# Utility Functions and Definitions
#
# Turn off forceful rm (RM is usually mapped to rm -f)
ifdef SAFE_RM
RM	:= rm
endif

# Don't call this directly - it is here to avoid calling wildcard more than
# once in remove-files.
remove-files-helper	= $(if $1,$(RM) $1,$(sh_true))

# $(call remove-files,file1 file2)
remove-files		= $(call remove-files-helper,$(wildcard $1))

# Removes all cleanable files in the given list
# $(call clean-files,file1 file2 file3 ...)
# Works exactly like remove-files, but filters out files in $(neverclean)
clean-files		= \
  $(if $VERBOSE, $(echo_dt) "$(C_WARNING) Clean files '$(wildcard $1)' $(C_RESET)",); \
	$(call remove-files-helper,$(call cleanable-files,$(wildcard $1)))

# Test that a file exists
# $(call test-exists,file)
test-exists		= [ -e '$1' ]
# $(call test-not-exists,file)
test-not-exists   = [ ! -e '$1' ]

# $(call move-files,source,destination)
move-if-exists		= $(call test-exists,$1) && $(MV) '$1' '$2'

# Copy file1 to file2 only if file2 doesn't exist or they are different
# $(call copy-if-different,sfile,dfile)
copy-if-different	= $(call test-different,$1,$2) && $(CP) '$1' '$2'
copy-if-exists		= $(call test-exists,$1) && $(CP) '$1' '$2'
move-if-different	= $(call test-different,$1,$2) && $(MV) '$1' '$2'
replace-if-different-and-remove	= \
	$(call test-different,$1,$2) \
	&& $(MV) '$1' '$2' \
	|| $(call remove-files,'$1')

# Note that $(DIFF) returns success when the files are the SAME....
# $(call test-different,sfile,dfile)
test-different		= ! $(DIFF) -q '$1' '$2' >/dev/null 2>&1
test-exists-and-different	= \
	$(call test-exists,$2) && $(call test-different,$1,$2)

# Return value 1, or value 2 if value 1 is empty
# $(call get-default,<possibly empty arg>,<default value if empty>)
get-default	= $(if $1,$1,$2)
# Utility function for creating larger lists of files
# $(call concat-files,suffixes,[prefix])
concat-files	= $(foreach s,$1,$($(if $2,$2_,)files.$s))

# Utility function for obtaining all files not specified in $(neverclean)
# $(call cleanable-files,file1 file2 file3 ...)
# Returns the list of files that is not in $(wildcard $(neverclean))
cleanable-files = $(filter-out $(wildcard $(neverclean)), $1)

# Gives a reassuring message about the failure to find include files
# $(call include-message,<list of include files>)
define include-message
$(strip \
$(if $(filter-out $(wildcard $1),$1),\
	$(shell $(echo_dt) \
	"$(C_INFO)NOTE: You may ignore warnings about the following files:" >&2;\
	$(ECHO) >&2; \
	$(foreach s,$(filter-out $(wildcard $1),$1),$(ECHO) '     $s' >&2;)\
	$(ECHO) "$(C_RESET)" >&2)
))
endef

# Characters that are hard to specify in certain places
space		:= $(empty) $(empty)
colon		:= \:
comma		:= ,

# Useful shell definitions
sh_true		:= :
sh_false	:= ! :

# Clear out the standard interfering make suffixes
.SUFFIXES:


# Terminal color definitions
REAL_TPUT 	:= $(if $(NO_COLOR),,$(shell $(WHICH) $(TPUT)))

# $(call get-term-code,codeinfo)
# e.g.,
# $(call get-term-code,setaf 0)
get-term-code = $(if $(REAL_TPUT),$(shell $(REAL_TPUT) $1),)

black   := $(call get-term-code,setaf 0)
red     := $(call get-term-code,setaf 1)
green   := $(call get-term-code,setaf 2)
yellow	:= $(call get-term-code,setaf 3)
blue	  := $(call get-term-code,setaf 4)
magenta	:= $(call get-term-code,setaf 5)
cyan	  := $(call get-term-code,setaf 6)
white	  := $(call get-term-code,setaf 7)
bold	  := $(call get-term-code,bold)
uline	  := $(call get-term-code,smul)
reset	  := $(call get-term-code,sgr0)

#
# User-settable definitions
#
MSG_COLOR_WARNING	  ?= magenta
MSG_COLOR_CLEAN 	  ?= magenta bold
MSG_COLOR_ERROR	    ?= red
MSG_COLOR_INFO	    ?= green
MSG_COLOR_UNDERFULL	?= magenta
MSG_COLOR_OVERFULL	?= red bold
MSG_COLOR_PAGES	    ?= bold
MSG_COLOR_BUILD	    ?= cyan
MSG_COLOR_RUN 	    ?= cyan bold
MSG_COLOR_GRAPHIC	  ?= yellow
MSG_COLOR_DEP		    ?= green
MSG_COLOR_SUCCESS	  ?= green bold
MSG_COLOR_FAILURE	  ?= red bold

# Gets the real color from a simple textual definition like those above
# $(call get-color,ALL_CAPS_COLOR_NAME)
# e.g., $(call get-color,WARNING)
get-color	= $(subst $(space),,$(foreach c,$(MSG_COLOR_$1),$($c)))

#
# STANDARD COLORS
#
C_WARNING	  := $(call get-color,WARNING)
C_ERROR		  := $(call get-color,ERROR)
C_INFO		  := $(call get-color,INFO)
C_UNDERFULL	:= $(call get-color,UNDERFULL)
C_OVERFULL	:= $(call get-color,OVERFULL)
C_PAGES		  := $(call get-color,PAGES)
C_BUILD		  := $(call get-color,BUILD)
C_RUN 		  := $(call get-color,RUN)
C_GRAPHIC	  := $(call get-color,GRAPHIC)
C_DEP		    := $(call get-color,DEP)
C_SUCCESS	  := $(call get-color,SUCCESS)
C_FAILURE	  := $(call get-color,FAILURE)
C_CLEAN	    := $(call get-color,CLEAN)
C_DISTCLEAN := $(call get-color,CLEAN)
C_RESET		  := $(reset)

get_date_time   = $(DATE) +"%F %T"

# Display information about what is being done
echo_dt       = $(ECHO) "$(shell $(get_date_time) )"
# $(call echo-build,<input file>,<output file>,[<run number>])
echo-build	  = $(echo_dt) "$(C_BUILD)**Build** $1 --> $2$(if $3, ($3),)...$(C_RESET)"
echo-run  	  = $(echo_dt) "$(C_RUN)**Run $1 ** $2 --> $3...$(C_RESET)"
echo-graphic  = $(echo_dt) "$(C_GRAPHIC)**Figure** $1 --> $2$(C_RESET)"
echo-dep	    = $(echo_dt) "$(C_DEP)**Deps** $1 --> $2$(C_RESET)"
echo-warning  = $(echo_dt) "$(C_WARNING)**/!\\ WARNING /!\\** $1 $(C_RESET)"

# Display a list of something
# $(call echo-list,<values>)
echo-list	= for x in $1; do $(ECHO) "$$x"; done

echo-end-target=$(call test-exists,$1)&& \
	  $(echo_dt) "$(C_SUCCESS) Successfully generated $1$(C_RESET)" ||\
	  $(echo_dt) "$(C_FAILURE) Fail to generate $1!!!$(C_RESET)" 



###############################################################################
# VARIABLE DECLARATIONS
#

ifeq "$(strip $(BUILD_HTML_STRATEGY))" "html"
endif

ifeq "$(strip $(BUILD_TEX_STRATEGY))" "pdflatex"
latex_build_program		    ?= $(PDFLATEX)
hyperref_driver_pattern		?= hpdf.*
hyperref_driver_error		  ?= Using pdflatex: specify pdftex in the hyperref options (or leave it blank).
endif

ifeq "$(strip $(BUILD_TEX_STRATEGY))" "xelatex"
latex_build_program		    ?= $(XELATEX)
hyperref_driver_pattern		?= hdvipdf.*
hyperref_driver_error		  ?= Using xelatex: specify xelatex in the hyperref options (or leave it blank).
endif

ifeq "$(strip $(BUILD_TEX_STRATEGY))" "lualatex"
latex_build_program		    ?= $(LUALATEX)
hyperref_driver_pattern		?= hdvipdf.*
hyperref_driver_error		  ?= Using xelatex: specify lualatex in the hyperref options (or leave it blank).
endif

ifdef GLOSSARIES
PANDOC_XML_FLAGS  += -V glossary=$(wildcard $(GLOSSARIES_XML))
PANDOC_TEX_FLAGS  += -V glossary=$(wildcard $(GLOSSARIES_TEX))
endif

###############################################################################
# Files of interest / Sources files searched in INDIR

files_frontmatter != $(FIND) $(INDIR) -name $(sources_frontmatter_pattern) -type f -prune  -print| $(SORT) | $(UNIQ)
files_mainmatter  != $(FIND) $(INDIR) -name $(sources_mainmatter_pattern)  -type f -prune  -print| $(SORT) | $(UNIQ)
files_backmatter  != $(FIND) $(INDIR) -name $(sources_backmatter_pattern)  -type f -prune  -print| $(SORT) | $(UNIQ)
files_sources     ?= $(files_frontmatter) $(files_mainmatter) $(files_backmatter)

files_noext       := $(basename $(files_sources))
files_mdh         := $(files_noext:$(INDIR)/%=$(MDHDIR)/%.mdh)
ifdef GLOSSARIES
files_mdh         := $(sort $(files_mdh) $(GLOSSARIES_MDH))
endif

# MDX
files_mdx         := $(files_noext:$(INDIR)/%=$(MDXDIR)/%.mdx)

# SCSS/CSS files
files_scss        := $(wildcard $(SCSSDIR)/*.scss)
files_css         := $(patsubst $(SCSSDIR)/%.scss,$(CSSDIR)/%.css,$(files_scss))
html_css          := $(filter %html.css,$(files_css))

## Figures
figures     != $(GREP) -sho '\($(FIGDIR)/[^{}\"\)]*\)' $(files_sources) | $(UNIQ)
mediafiles  := $(patsubst $(FIGDIR)/%,$(MEDIADIR)/%,$(figures))
fig_svg	    := $(figures:%=$(OUTDIR)/%.svg)
fig_pdf	    := $(figures:%=$(OUTDIR)/%.pdf)
fig_png	    := $(figures:%=$(OUTDIR)/%.png)
fig_emf	    := $(figures:%=$(OUTDIR)/%.emf)

################################################################################
# Dependancies
dir_deps  += $(OUTDIR) $(MDHDIR) $(HTMLDIR) $(MDXDIR) $(XMLDIR) $(MDTDIR) $(OUT_FIGDIR) $(CSSDIR)
base_deps += $(files_sources) $(METADATA) $(VARSDATA) $(PP_MACROS)
bib_deps  += $(CSL) $(BIBFILES)
css_deps  += $(SCSSINCS) $(foreach d,  $(SCSSINCS), $(wildcard $(d)/*.scss))
mdh_deps	+= $(MDHDIR) $(files_mdh) $(base_deps) $(PP_HTML_MACROS)  $(bib_deps)
html_deps	+= $(HTMLDIR) $(OUT_FIGDIR) $(mdh_deps) $(TEMPLATEDIR)/template.html5 \
  $(SCSSINCS) $(html_css) $(fig_svg)
ifdef GLOSSARIES
html_deps += $(PP_GLO_HTML)
endif
ifeq ($(BUILD_HTML_FORMAT), htmlmulti)
html_deps += $(htmlmuli_temp)
endif

epub_deps	+= $(mdh_deps) $(TEMPLATEDIR)/template.epub3 \
  $(SCSSINCS) $(filter %epub.css,$(files_css))  $(fig_svg)
docx_deps	+= $(OUTDIR) $(mdh_deps) $(TEMPLATEDIR)/template.docx $(fig_emf)
odt_deps	+= $(OUTDIR) $(mdh_deps) $(TEMPLATEDIR)/template.odt  $(fig_png)

mdx_deps  += $(MDXDIR) $(files_mdx) $(base_deps) $(PP_XML_MACROS)  $(bib_deps)
xml_deps  += $(XMLDIR) $(OUT_FIGDIR) $(mdx_deps) $(TEMPLATEDIR)/template.docbook5 \
  $(SCSSINCS) $(filter %docbook.css,$(files_css)) $(fig_svg)

ifdef GLOSSARIES
xml_deps    += $(PP_GLO_XML) $(GLOSSARIES_XML)
XSLT_FLAGS  += --stringparam glossary.collection $(GLOSSARIES_XML)
endif
################################################################################
# clean
clean_subdirs   		+= $(MDDIR) $(DATADIR) $(BIBDIR) $(FIGDIR) $(HTMLDIR) $(TEXDIR) 
clean_patterns      += *~ *.bak
clean_files         += $(foreach d,$(clean_subdirs),$(addprefix $(d)/,$(clean_patterns))) $(BIB)
clean_css_files     += $(files_css)
clean_fig           += $(fig_svg) $(fig_pdf) $(fig_png) $(fig_emf)
clean_mdh_files     += $(files_mdh)
clean_mdx_files     += $(files_mdx)
clean_html_files    += $(wildcard $(HTMLDIR)/*.html)
clean_epub_files    += $(wildcard $(HTMLDIR)/*.epub)
clean_docx_files    += $(wildcard $(HTMLDIR)/*.docx)
clean_odt_files     += $(wildcard $(HTMLDIR)/*.odt)
clean_xml_files     += $(wildcard $(HTMLDIR)/*.xml)

# distclean
distclean_subdirs   +=$(NODEDIR) $(HTMLDIR) $(TEXDIR) 

###############################################################################
# DEFAULT TARGET
#

.PHONY: all
all: $(BUILD_DEFAULT_TARGETS)


ifdef WATCH
watch-html:
	$(QUIET)$(WATCH) html
watch-xml:
	$(QUIET)$(WATCH) xml
watch-pdf:
	$(QUIET)$(WATCH) pdf
endif

test:
	$(QUIET)$(ECHO) "fig_svg  $(fig_svg) "
################################################################################
# MAIN TARGETS
#

# HTML Output target
.PHONY: html
#.SECONDARY: $(HTMLDIR)/$(MAIN_DOC_BASENAME).html
html: 
ifeq ($(BUILD_HTML_FORMAT), htmlsimple)
	$(QUIET)$(MAKE) $(HTMLDIR)/$(MAIN_DOC_BASENAME).html
endif
ifeq ($(BUILD_HTML_FORMAT), htmlmulti)
	$(QUIET)$(MAKE) run-jekyll;
endif
ifeq ($(BUILD_HTML_FORMAT), html_db_chunk)
	$(QUIET)$(MAKE) xml-chunk
endif

html-deps:$(html_deps)
	$(QUIET)$(call echo-dep,html,$(html_deps))

ifeq ($(BUILD_HTML_FORMAT), htmlsimple)
$(HTMLDIR)/$(MAIN_DOC_BASENAME).html: $(html_deps)
	$(QUIET)$(call echo-run,$(PANDOC),,$@)
	$(QUIET)$(PANDOC) -f markdown$(PANDOC_MDEXT) \
	  $(PANDOC_FLAGS) $(VARSDATA) $(PANDOC_HTML_FLAGS)\
	  $(files_mdh) -t html5 -o $@ 
	$(call echo-end-target,$@)
endif

## EPUB Output target
.PHONY: epub
#.SECONDARY: $(OUTDIR)/$(MAIN_DOC_BASENAME).epub
epub: $(OUTDIR)/$(MAIN_DOC_BASENAME).epub

$(OUTDIR)/$(MAIN_DOC_BASENAME).epub:$(epub_deps)
	$(QUIET)$(call echo-run,$(PANDOC),,$@)
	$(QUIET)$(PANDOC) -f markdown$(PANDOC_MDEXT) \
	  $(PANDOC_FLAGS) $(VARSDATA) $(PANDOC_EPUB_FLAGS)\
	  $(files_mdh) -t epub3 -o $@ 	
	$(call echo-end-target,$@)

## DOCX Output target
.PHONY: docx
#.SECONDARY: $(OUTDIR)/$(MAIN_DOC_BASENAME).docx
docx:  $(OUTDIR)/$(MAIN_DOC_BASENAME).docx

$(OUTDIR)/$(MAIN_DOC_BASENAME).docx:$(docx_deps)
	$(QUIET)$(call echo-run,$(PANDOC),,$@)
	$(QUIET)$(PANDOC) -f markdown$(PANDOC_MDEXT) \
	  $(PANDOC_FLAGS) $(VARSDATA) $(PANDOC_DOCX_FLAGS)\
	  $(files_mdh) -t docx -o $@ 	
	$(call echo-end-target,$@)

## ODT Output target
.PHONY: odt
#.SECONDARY: $(OUTDIR)/$(MAIN_DOC_BASENAME).odt
odt:  $(OUTDIR)/$(MAIN_DOC_BASENAME).odt

$(OUTDIR)/$(MAIN_DOC_BASENAME).odt:$(odt_deps)
	$(QUIET)$(call echo-run,$(PANDOC),,$@)
	$(QUIET)$(PANDOC) -f markdown$(PANDOC_MDEXT) \
	  $(PANDOC_FLAGS) $(VARSDATA) $(PANDOC_ODT_FLAGS)\
	  $(files_mdh) -t odt -o $@ 
	$(call echo-end-target,$@)

# XML/DocBook Output target
.PHONY: xml
#.SECONDARY: $(XMLDIR)/$(MAIN_DOC_BASENAME).xml
xml: $(XMLDIR)/$(MAIN_DOC_BASENAME).xml
	$(QUIET)$(call echo-warning,"XML/DocBook outputs are unmaintened") 
xml-chunk:$(XMLDIR)/$(MAIN_DOC_BASENAME).xml
	$(QUIET)$(call echo-warning,"XML/DocBook outputs are unmaintened") 
	$(QUIET)$(MKDIR) $(CHUNKDIR)/
	$(QUIET)$(call echo-run,$(XSLTPROC),,$@)
	$(QUIET)$(XSLTPROC) $(XSLT_FLAGS) -o $(CHUNKDIR)/ $(XSL) $<

$(XMLDIR)/$(MAIN_DOC_BASENAME).xml: $(xml_deps)
	$(QUIET)$(call echo-warning,"XML/DocBook '$@' is unmaintened") 
	$(QUIET)$(call echo-run,$(PANDOC),,$@)
	$(QUIET)$(PANDOC) -f markdown$(PANDOC_MDEXT) \
	  $(PANDOC_FLAGS) $(VARSDATA) $(PANDOC_XML_FLAGS)\
	  $(files_mdx) -t docbook5 -o $@ 
	$(SED) -e 's/sec:/sec-/g' -e 's/fig:/fig-/g' -e 's/tbl:/tbl-/g' -e 's/eq:/eq-/g' -e 's/[^xml:]id=/ xml:id=/g' < $@ > $@.sed && \
	  $(call replace-if-different-and-remove,$@.sed,$@)
	$(call echo-end-target,$@)

# TeX/PDF Output target
.PHONY: pdf
#.SECONDARY: $(TEXDIR)/$(MAIN_DOC_BASENAME).pdf
pdf: $(TEXDIR)/$(MAIN_DOC_BASENAME).pdf

$(TEXDIR)/$(MAIN_DOC_BASENAME).pdf:
	$(QUIET)$(ECHO) "$(C_FAILURE) build of $@ not yet implemented$(C_RESET)"

# Merge all bibliography in BIB
.PHONY: biblio
biblio:$(BIB)
$(BIB):$(BIBFILES)
	$(QUIET)$(call echo-build,"Merge",$(BIBFILES),$@)
	$(QUIET)$(MKDIR) $(OUT_BIBDIR)
	$(QUIET)$(CAT) $(BIBFILES) > $(BIB)

#########################
# Intermediate MDH rules for html/epub/docx/odt 
#.INTERMEDIATE: $(files_mdh)
$(MDHDIR)/%.mdh:$(MDDIR)/%.md
	$(QUIET)$(call echo-run,$(PANDOC),$<,$@)
	$(QUIET)$(MKDIR) $(MDHDIR)
	$(PP) $(PP_FLAGS) -DHTML=1 -import=$(PP_MACROS) -import=$(PP_GLO_HTML) $< | \
	  $(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) -t markdown$(PANDOC_MDEXT) -o "$@"
	$(QUIET)$(SED)  -e 's/\]\s*\[@/; @/g' < $@ > $@.sed && \
	  $(call replace-if-different-and-remove,$@.sed,$@)
	  
# Intermediate MDX rules for xml/docbook
#.INTERMEDIATE: $(files_mdx)
$(MDXDIR)/%.mdx:$(MDDIR)/%.md
	$(QUIET)$(call echo-run,$(PANDOC),$<,$@)
	$(QUIET)$(MKDIR) $(MDXDIR)
	$(PP) $(PP_FLAGS) -DXML=1 -import=$(PP_MACROS) -import=$(PP_GLO_XML) $< | \
	  $(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) -t markdown$(PANDOC_MDEXT) -o "$@"
	$(QUIET)$(SED)  -e 's/\]\s*\[@/; @/g' < $@ > $@.sed && \
	  $(call replace-if-different-and-remove,$@.sed,$@)
	  
################################################################################
#  Intermediate Glossaries rules
$(GLOSSARIES_MDH) $(PP_GLO_HTML): $(GLOSSARIES) $(PP_HTML_MACROS) $(PP_MACROS)
	$(QUIET)$(call echo-run,$(PP),$<,$@)
	$(QUIET)$(MKDIR) $(MDHDIR)
	$(PP) $(PP_FLAGS) -DHTML=1 -import=$(PP_MACROS) -D_PP_GLO_TMP=$(PP_GLO_HTML) $(GLOSSARIES) > $(GLOSSARIES_MDH)

$(GLOSSARIES_XML) $(PP_GLO_XML): $(GLOSSARIES) $(PP_XML_MACROS) $(PP_MACROS)
	$(QUIET)$(call echo-run,$(PP),$<,$@)
	$(QUIET)$(MKDIR) $(MDXDIR)
	$(PP) $(PP_FLAGS) -DXML=1 -import=$(PP_MACROS) -D_PP_GLO_TMP=$(PP_GLO_XML)  $(GLOSSARIES) > $(GLOSSARIES_XML)

########################
# Intermediate CSS rules
.SECONDARY: $(files_css)
$(CSSDIR)/%.css:$(SCSSDIR)/%.scss $(css_deps)
	$(QUIET)$(call echo-run,$(SASS),$<,$@)
	$(QUIET)$(MKDIR) $(CSSDIR); 	$(SASS) $(SASS_FLAGS) $< $@

.SECONDARY:  $(NODEDIR)/bootstrap/scss
$(NODEDIR)/bootstrap/scss: $(NODEDIR)/bootstrap
	$(QUIET)$(ECHO) "$(C_INFO) Bootstrap is in '$(NODEDIR)/bootstrap/' folder$(C_RESET)"
	$(QUIET)$(NPM) update bootstrap

$(SASS):$(NODEDIR)/sass
	$(QUIET)$(ECHO) "$(C_INFO) SASS is  in '$(NODEDIR)/sass'$(C_RESET)"

# get bootstrap and its dependancies
bootstrap:$(NODEDIR)/bootstrap
	$(QUIET)$(ECHO) "$(C_INFO) Bootstrap is in '$(NODEDIR)/bootstrap'$(C_RESET)"
################################################################################
#  Intermediate Figures rules
# Converts svg files into .eps files
#
.PHONY: svg
svg:$(fig_svg) $(OUT_FIGDIR)
$(FIGDIR)/%.svg:$(MEDIADIR)/%.svg
	$(QUIET)$(call echo-graphic,$^,$<,$@)
	$(QUIET)$(INKSCAPE) --vacuum-defs --export-area-page --export-plain-svg=$@ $<
ifeq "$(if $(shell $(WHICH) $(SVGO) 2>/dev/null),1,)" "1"
	$(QUIET)$(SVGO) --enable={cleanupIDs,collapseGroups,removeUnusedNS,removeUselessStrokeAndFill,removeUselessDefs,removeComments,removeMetadata,removeEmptyAttrs,removeEmptyContainers} $@
endif

$(OUT_FIGDIR)/%.svg:$(MEDIADIR)/%.png
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(CONVERT) $< $@
$(OUT_FIGDIR)/%.svg:$(MEDIADIR)/%.jpg
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(CONVERT) $< $@
$(OUT_FIGDIR)/%.svg:$(MEDIADIR)/%.tif
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(CONVERT) $< $@
	
$(OUT_FIGDIR)/%.emf:$(MEDIADIR)/%.svg
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(INKSCAPE) --vacuum-defs --export-area-page --export-emf=$@ $<
	
$(OUT_FIGDIR)/%.emf:$(OUT_FIGDIR)/%.svg
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(INKSCAPE) --vacuum-defs --export-area-page --export-emf=$@ $<

################################################################################
# PREPARE TARGETS
#
dir_prep = $(sort $(dir_deps))
.PHONY: prepare dirs $(dir_prep)
prepare: dirs $(prepare_targets)
dirs: $(dir_prep)
$(dir_prep):
	$(QUIET)$(MKDIR) $@
ifeq ($(BUILD_HTML_FORMAT), htmlmulti)
	$(QUIET)$(MAKE) $(htmlmuli_temp)
endif

# Install a npm module
$(NODEDIR)/%:
	$(QUIET)$(ECHO) "$(C_INFO) $@ will be installed in the local folder$(C_RESET)"
	$(QUIET)$(call echo-run,$(NPM),$<,$@)
	$(QUIET)$(ECHO) "npm install $(@:$(NODEDIR)/%=%)"
	$(QUIET)$(ECHO) "$(C_INFO) $(@:$(NODEDIR)/%=%) is now in '$@'$(C_RESET)"

ifeq ($(BUILD_HTML_FORMAT), htmlmulti)
REAL_BUNDLE   := $(shell $(WHICH) $(BUNDLE))
REAL_JEKYLL   := $(BUNDLE) exec $(JEKYLL)

htmlmuli_temp ?= $(OUTDIR)/htmlmuli.tmp
htmlmulti_mdh := $(files_mdh:$(MDHDIR)/%.mdh=$(htmlmuli_temp)/%.mdh)
htmlmulti_md  := $(htmlmulti_mdh:%.mdh=%.md)
htmlmulti_dep += $(htmlmuli_temp) $(htmlmuli_temp)/$(MAIN_DOC_BASENAME).mdh\
  $(htmlmulti_md) $(htmlmuli_temp)/.synced

$(htmlmuli_temp):
	$(QUIET)$(echo_dt) "$(C_BUILD)Prepare 'htmlmuti' output with jekyll in '$(htmlmuli_temp)' $(C_RESET)"
	$(QUIET)$(MKDIR) $(htmlmuli_temp)
$(htmlmuli_temp)/.synced: $(htmlmuli_temp) $(wildcard $(TEMPLATEJEKYLLDIR)/*)
	$(QUIET)$(call echo-run,$(RSYNC),$<,$@)
	$(QUIET)$(call clean-files,$(htmlmuli_temp)/.synced)
	$(QUIET)$(RSYNC) $(RSYNC_FLAGS) $(TEMPLATEJEKYLLDIR)/* $(htmlmuli_temp)\
	&& $(TOUCH) $(htmlmuli_temp)/.synced

htmlmulti_dep   += $(htmlmuli_temp)/metadata.yml $(htmlmuli_temp)/variables.yml

$(htmlmuli_temp)/metadata.yml: $(METADATA)
	$(QUIET)$(call echo-run,$(RSYNC),$<,$@)
	$(QUIET)$(RSYNC) $(RSYNC_FLAGS) $(METADATA) $(htmlmuli_temp)/

$(htmlmuli_temp)/variables.yml: $(VARSDATA)
	$(QUIET)$(call echo-run,$(RSYNC),$<,$@)
	$(QUIET)$(RSYNC) $(RSYNC_FLAGS) $(VARSDATA) $(htmlmuli_temp)/_data/
	
htmlmulti_csl   := $(htmlmuli_temp)/assets/bib/$(notdir $(CSL))
htmlmulti_bib   := $(htmlmuli_temp)/assets/bib/$(notdir $(BIB))
htmlmulti_dep   += $(htmlmulti_csl) $(htmlmulti_bib)

$(htmlmulti_csl): $(CSL)
	$(QUIET)$(call echo-run,$(RSYNC),$<,$@)
	$(QUIET)$(RSYNC) $(RSYNC_FLAGS) $(CSL) $(htmlmuli_temp)/assets/bib/
$(htmlmulti_bib): $(BIB)
	$(QUIET)$(call echo-run,$(RSYNC),$<,$@)
	$(QUIET)$(RSYNC) $(RSYNC_FLAGS) $(BIB) $(htmlmuli_temp)/assets/bib/

htmlmulti_css   := $(html_css:$(CSSDIR)/%.css=$(htmlmuli_temp)/assets/css/%.css)
htmlmulti_dep   += $(htmlmulti_css)
$(htmlmuli_temp)/assets/css/%.css: $(CSSDIR)/%.css
	$(QUIET)$(call echo-run,$(RSYNC),$<,$@)
	$(QUIET)$(RSYNC) $(RSYNC_FLAGS) $< $@

htmlmulti_fig   := $(fig_$(default_image_extension):$(OUT_FIGDIR)/%.$(default_image_extension)=$(htmlmuli_temp)/assets/fig/%.$(default_image_extension))
htmlmulti_dep   += $(htmlmulti_fig)
$(htmlmuli_temp)/assets/fig/%: $(OUT_FIGDIR)/%
	$(QUIET)$(call echo-run,$(RSYNC),$<,$@)
	$(QUIET)$(RSYNC) $(RSYNC_FLAGS) $< $@
	
$(htmlmuli_temp)/.bundle_installed: | $(htmlmuli_temp)
	$(QUIET)$(call echo-run,$(GEM),$(REAL_BUNDLE))
	$(QUIET)$(call clean-files,$(htmlmuli_temp)/.bundle_installed)
	$(QUIET)cd $(htmlmuli_temp) && $(GEM) install bundler && cd -\
	&& $(TOUCH) $(htmlmuli_temp)/.bundle_installed

$(htmlmuli_temp)/.jekyll_installed: |$(htmlmuli_temp) $(htmlmuli_temp)/.bundle_installed 
	$(QUIET)$(call echo-run,$(BUNDLE),Jekyll)
	$(QUIET)$(call clean-files,$(htmlmuli_temp)/.jekyll_installed)
	$(QUIET)cd $(htmlmuli_temp) && $(REAL_BUNDLE) update && cd - \
	&& $(TOUCH) $(htmlmuli_temp)/.jekyll_installed


$(htmlmuli_temp)/%.mdh:$(MDHDIR)/%.mdh
	$(QUIET)$(call echo-run,$(RSYNC),$<,$@)
	$(QUIET)$(RSYNC) $(RSYNC_FLAGS) $< $@

$(htmlmuli_temp)/$(MAIN_DOC_BASENAME).mdh: $(htmlmulti_mdh) $(htmlmuli_temp)/variables.yml 
	$(QUIET)$(call echo-run,"Prepare Markdown for jekyll [1]",$<,$@)
	$(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) $(PANDOC_MDH_FLAGS) -t markdown$(PANDOC_MDEXT) $(htmlmulti_mdh) -o "$@"

$(htmlmuli_temp)/%.md_tmp:$(htmlmuli_temp)/%.mdh
	$(QUIET)$(call echo-run,"Prepare Markdown for jekyll [1]",$<,$@)
	$(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) $(PANDOC_MDH_FLAGS) -t markdown$(PANDOC_MDEXT) $< -o "$@"

$(htmlmuli_temp)/%.md:$(htmlmuli_temp)/%.md_tmp $(htmlmuli_temp)/%.mdh
	$(QUIET)$(call echo-run,"Prepare Markdown for jekyll [2]",$<,$@)
	$(QUIET)$(ECHO) -e "---\nlayout: default\n"> $@
	$(EGREP) '^# ' $< | $(SED) -e 's/^# \(.*\)[[:space:]]*\({#.*}\)/title: \1/g' >> $@
	$(ECHO) "section: "  >> $@
	$(EGREP) '^## ' $< | $(SED) \
	  -e 's/^## \(.*\)[[:space:]]*{#\(.*\)}/  - \n    title: \1\n    ref: \2/g'\
	  -e 's/^## \(.*\)/  - \1/g'  >> $@
	$(QUIET)$(ECHO)  "---">> $@
	$(QUIET)$(CAT) $(basename $<).mdh >> $@	
	$(QUIET)$(ECHO) "Try to fix undefined references... "
	undefined_ref=`$(EGREP) -oh "\*\*¿[^ .]*" $< | $(SED) -e 's/[\*¿\?]//g'`;\
	  for unref in $${undefined_ref}; do \
	    found_in=`$(EGREP) -l "\{#$${unref}\}" $(files_mdh) | tr -d '\n'` ; \
	    found_name=`basename $${found_in} .mdh` ; \
	    found_lbl=`$(EGREP) -oh "\[[^]]*\]\(#$${unref}\)" $(htmlmuli_temp)/$(MAIN_DOC_BASENAME).mdh | $(SED) -e "s/(#$${unref})/($${found_name}#$${unref})/g" `; \
	    $(ECHO) "Found underfined ref '$${unref}' in $${found_in} with $${found_lbl}...";\
	    $(SED) -e "s/\[@$${unref}\]/$${found_lbl}/" $@ > $@.sed && \
	  $(call replace-if-different-and-remove,$@.sed,$@); \
	  done
	$(call clean-files,$<) 

#	$(ECHO) " donot remove $< ..."
#sed -e 's/^## \(.*\)[[:space:]]*{#\(.*\)}/section: [\1,\2]/g'
#	$(SED) -e 's/\[@\([^]]*\)\]/{% cite \1%}/g' < $@ > $@.sed && \
#	  $(call replace-if-different-and-remove,$@.sed,$@)

#	$(QUIET)$(SED)  -e 's/\]\s*\[@/; @/g' < $@ > $@.sed && 

.PHONY: run-jekyll 
run-jekyll: $(htmlmulti_dep)  | $(htmlmuli_temp)/.jekyll_installed 
	$(QUIET)$(call echo-build,$(JEKYLL),htmlmulti)
	$(call clean-files,$(htmlmulti_mdh)) 
	$(QUIET)cd $(htmlmuli_temp) && $(REAL_JEKYLL) build -d ../../$(CHUNKDIR) && cd -

serve-jekyll:$(htmlmulti_dep)|$(htmlmuli_temp)/.jekyll_installed 
	$(QUIET)$(call echo-build,$(JEKYLL),htmlmulti)
	$(QUIET)cd $(htmlmuli_temp) && $(REAL_JEKYLL) serve && cd -
#
endif
################################################################################
# CLEAN TARGETS
#
.PHONY: clean-all clean-html
clean-all: clean-files clean-mdh clean-html clean-css clean-fig 
clean-files:
	$(QUIET)$(echo_dt) "$(C_WARNING) Cleaning unnecessary documents...$(C_RESET)"
	$(call clean-files, $(clean_files))

clean-mdh:
	$(QUIET)$(echo_dt) "$(C_WARNING) Cleaning Markdown/Html intermediates...$(C_RESET)"
	$(call clean-files, $(clean_mdh_files))

clean-html: clean-files
	$(QUIET)$(echo_dt) "$(C_WARNING) Clean HTML $(clean_html_files)...$(C_RESET)"
	$(call clean-files, $(clean_html_files))
	
clean-css:
	$(QUIET)$(echo_dt) "$(C_WARNING) Clean CSS intermediates...$(C_RESET)"
	$(call clean-files, $(clean_css_files))

clean-fig:
	$(QUIET)$(echo_dt) "$(C_WARNING) Clean unnecessary figures...$(C_RESET)"
	$(call clean-files, $(clean_fig))

	
# DISTCLEAN TARGETS
# Remove all intermediate
.PHONY: distclean
distclean: distclean-dirs
distclean-dirs: clean-all
	$(QUIET)$(echo_dt) "$(C_ERROR) Distclean unnecessary subdirs of the project$(C_RESET)"
	$(QUIET)$(call clean-files, $(distclean_files))
	$(QUIET)$(RM) -r $(distclean_subdirs)
  
################################################################################
# HELPFUL PHONY TARGETS
#

.PHONY: _all_programs
_all_programs:
	$(QUIET)$(ECHO) "# All External Programs Used"
	$(QUIET)$(call output-all-programs)

.PHONY: _check_programs
_check_programs:
	$(QUIET)$(ECHO) "== Checking Makefile Dependencies =="; $(ECHO)
	$(QUIET) \
	allprogs=`\
	 ($(call output-all-programs)) | \
	 $(SED) \
	 -e 's/^[[:space:]]*//' \
	 -e '/^#/d' \
	 -e 's/[[:space:]]*#.*//' \
	 -e '/^=/s/[[:space:]]/_/g' \
	 -e '/^[[:space:]]*$$/d' \
	 -e 's/^[^=].*=[[:space:]]*\([^[:space:]]\{1,\}\).*$$/\\1/' \
	 `; \
	spaces='                             '; \
	for p in $${allprogs}; do \
	case $$p in \
		=*) $(ECHO); $(ECHO) "$$p";; \
		*) \
			$(ECHO) -n "$$p:$$spaces" | $(SED) -e 's/^\(.\{0,20\}\).*$$/\1/'; \
			loc=`$(WHICH) $$p`; \
			if [ x"$$?" = x"0" ]; then \
				$(ECHO) "$(C_SUCCESS)Found:$(C_RESET) $$loc"; \
			else \
				$(ECHO) "$(C_FAILURE)Not Found$(C_RESET)"; \
			fi; \
			;; \
	esac; \
	done
	
.PHONY: _all_sources
_all_sources:
	$(QUIET)$(echo_dt) "== All Sources =="
	$(QUIET)$(call echo-list,$(sort $(files_sources)))


# DO NOT DELETE
