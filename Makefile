################################################################################
## Copyright (c) 2018 David Folio
## All rights reserved.
################################################################################
##  License : under CC by license style...
################################################################################

.DEFAULT_GOAL  ?= all
# Note that the user-global version is imported *after* the source directory,
# so that you can use stuff like ?= to get proper override behavior.
-include Makefile.ini

################################################################################
# SIMPLE CONFIGURATION #########################################################

#Select the output mode for HTML and TeX 
#BUILD_OUTPUT_MODE    ?= multi
BUILD_OUTPUT_MODE   ?= single

#Select the prefered build strategy
#BUILD_TEX_STRATEGY  ?= pdflatex
BUILD_TEX_STRATEGY  ?= lualatex
#BUILD_TEX_STRATEGY  ?= xelatex

# Select the citation TEX_BIB_STRATEGY for LateX:
#   - biblatex: intended for use in producing a LaTeX file that can be processed with bibtex or biber.
#     Note: by default in VARSDATA biber backend are used. 
#     See also the BUILD_BIB_STRATEGY below.
#   - natbib: intended for use in producing a LaTeX file that can be processed with bibtex.
TEX_BIB_STRATEGY  ?= biblatex
#TEX_BIB_STRATEGY  ?= natbib

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
KEEP_TEMP    ?=

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
MDDIR       ?=_md
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
OUTDIR      ?= build

ROOTDIR     := $(PWD)

# Name use for distribution/archive, ie. used for 
#  make dist 
#
DISTNAME    ?=$(notdir $(PWD))

# Subdirs 
# where all templates are stored
TEMPLATEDIR ?=_layouts
TEMPLATEJEKYLLDIR   ?= $(TEMPLATEDIR)/jekyll
# data, variables, macros, glossaries should be placed in DATADIR
DATADIR     ?=_data
# various stuff can be placed ASSETSDIR such as bib, media, fonts...
# but, "publishable" (eg. in case of html outputs) files must be placed 
# in "$(OUT_ASSETSDIR)"
# Some subdir of the initial ASSETSDIR could be copied   "$(OUT_ASSETSDIR)"
ASSETSDIR       ?=assets
OUT_ASSETSDIR   ?=$(OUTDIR)/$(ASSETSDIR)
BIBDIR      ?=$(ASSETSDIR)/bib
OUT_BIBDIR  ?=$(OUT_ASSETSDIR)/bib
FONTDIR     ?=$(ASSETSDIR)/fonts
OUT_FONTDIR ?=$(OUT_ASSETSDIR)/fonts
MEDIADIR    ?=$(ASSETSDIR)/media
FIGDIR      ?=$(ASSETSDIR)/fig
OUT_FIGDIR  ?=$(OUT_ASSETSDIR)/fig
# Output directories for intermediates files 
MDHDIR      ?=$(OUTDIR)/mdh
MDXDIR      ?=$(OUTDIR)/mdx
MDTDIR      ?=$(TEXDIR)
TEXDIR      ?=$(OUTDIR)/tex
HTMLDIR     ?=$(OUTDIR)
HTMLMULTIDIR?=$(OUTDIR)/html
XMLDIR      ?=$(OUTDIR)
CHUNKDIR    ?=$(HTMLMULTIDIR)
# SASS/CSS dirs 
CSSDIR      ?=$(OUT_ASSETSDIR)/css
SCSSDIR     ?=$(ASSETSDIR)/scss
SASSDIR     ?=$(ASSETSDIR)/scss#deprecated: future removal!
# created by npm (nodejs)
NODEDIR     ?=node_modules
SCSSINCS    ?=$(SCSSDIR) $(NODEDIR)/bootstrap/scss

prepare_targets+=$(NODEDIR)/bootstrap/

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
METADATA    ?=$(DATADIR)/metadata.yml
## Edit the VARSDATA to customize pandoc
VARSDATA    ?=$(DATADIR)/variables.yml
## Put here all the necessary bibliography files
BIBFILES    ?=$(BIBDIR)/string.bib $(BIBDIR)/thesis-biblio.bib
## Where all bibliographies are merged
BIB         ?=$(OUT_BIBDIR)/bibliography.bib
CSL          ?=$(TEMPLATEDIR)/Thesis-ieee-style.csl
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
MKDIR     ?= mkdir -p
MKTEMP    ?= mktemp
MV        ?= mv -f
SED       ?= sed
SORT      ?= sort
TOUCH     ?= touch
UNIQ      ?= uniq
WHICH     ?= which
# == Pandoc Utilities
PANDOC    ?=pandoc
PP        ?=pp
# == LaTeX (tetex-provided)
BIBTEX    ?= bibtex
BIBER     ?= biber
LATEX     ?= latex
PDFLATEX  ?= pdflatex
LUALATEX  ?= lualatex
XELATEX   ?= xelatex
MAKEINDEX	?= makeindex
XINDY     ?= xindy
KPSEWHICH ?= kpsewhich
# == Makefile Color Output
TPUT      ?= tput
# == Figures Generation/Conversion
CONVERT   ?= convert      # ImageMagick
INKSCAPE  ?= inkscape -z  # Inkscape (svg support)
SVGO      ?= svgo         # SVG optimizer/minification
SCOUR     ?= scour        # SVG optimizer/minification
# == Usefull external program 
TAR       ?= tar          # To make archive
ZIP       ?= zip
NPM       ?= npm          # Install node_modules/<modules>
RUBY      ?= ruby         # 
GEM       ?= gem
BUNDLE    ?= bundle
JEKYLL    ?= jekyll
SASS      ?= $(NODEDIR)/.bin/sass
RSYNC     ?= rsync 
XSLTPROC  ?= xsltproc

# This ensures that even when echo is a shell builtin, we still use the binary
# (the builtin doesn't always understand -n)
FIXED_ECHO:= $(if $(findstring -n,$(shell $(ECHO) -n)),$(shell $(WHICH) echo),$(ECHO))
ECHO      := $(if $(FIXED_ECHO),$(FIXED_ECHO),$(ECHO))

TODAY     := $(shell $(DATE) +"%F")

################################################################################
# Default FLAGS
#

# Default image extension. 
# Suitable value can be svg (prefered) or png
default_image_extension ?= svg

RSYNC_FLAGS   ?= -r -t -p -o -g -l -c -z -u -s -a

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
PANDOC_MDH_FLAGS  ?= --file-scope -F pandoc-crossref

## Options for HTML output
## Note CSS files must be defined in VARSDATA file not here
PANDOC_HTML_FLAGS ?= $(PANDOC_MDH_FLAGS) \
  $(PANDOC_CITEPROC_FLAGS) --file-scope --standalone\
  --default-image-extension=$(default_image_extension) --mathjax \
  --template=$(TEMPLATEDIR)/template.html5
  
## Options for XML/DocBook output
PANDOC_XML_FLAGS ?= $(PANDOC_MDH_FLAGS) $(PANDOC_CITEPROC_FLAGS)\
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

ifeq "$(strip $(TEX_BIB_STRATEGY))" "biblatex"
PANDOC_TEX_BIB_FLAGS  += --biblatex
endif
ifeq "$(strip $(TEX_BIB_STRATEGY))" "natbib"
PANDOC_TEX_BIB_FLAGS  += --natbib
endif

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

# Turn on final version of the document
ifdef PROD
undefine VERBOSE
undefine DRAFT
undefine KEEP_TEMP
SASS_FLAGS += --style=compressed
endif
# Manage quiet/verbose mode 
ifndef VERBOSE
QUIET  := @
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
WRITE_LOG   ?= 1
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
SHELL       += -x
WRITE_LOG   ?= 1
endif

# Get the name of this makefile (always right in 3.80, often right in 3.79)
# This is only really used for documentation, so it isn't too serious.
ifdef MAKEFILE_LIST
this_file  := $(firstword $(MAKEFILE_LIST))
else
this_file  := $(wildcard GNUmakefile makefile Makefile)
endif

###############################################################################
# Utility Functions and Definitions
#

# Characters that are hard to specify in certain places
space    := $(empty) $(empty)
colon    := \:
comma    := ,

# Useful shell definitions
sh_true  := :
sh_false := ! :

# Clear out the standard interfering make suffixes
.SUFFIXES:

# Turn off forceful rm (RM is usually mapped to rm -f)
ifdef SAFE_RM
RM  := rm
endif

# Don't call this directly - it is here to avoid calling wildcard more than
# once in remove-files.
remove-files-helper = $(if $1,$(RM) $1,$(sh_true))

# $(call remove-files,source destination)
remove-files        = $(call remove-files-helper,$(wildcard $1))

# Removes all cleanable files in the given list
# $(call clean-files,source destination file3 ...)
# Works exactly like remove-files, but filters out files in $(neverclean)
clean-files    = \
  $(if $(VERBOSE),\
  $(echo_dt) "$(C_WARNING)Clean files '$1'$(C_RESET)",:); \
  $(call remove-files,$(call cleanable-files,$(wildcard $1)))

# $(call remove-temporary-files,filenames)
remove-temporary-files  = $(if $(KEEP_TEMP),:,$(call clean-files,$1))

# Test that a file exists
# $(call test-exists,file)
test-exists    = [ -e '$1' ]
# $(call test-not-exists,file)
test-not-exists   = [ ! -e '$1' ]

# Note that $(DIFF) returns success when the files are the SAME....
# $(call test-different,source,destination)
test-different            = ! $(DIFF) -q '$1' '$2' >/dev/null 2>&1
test-exists-and-different  = $(call test-exists,$2) && $(call test-different,$1,$2)

# $(call move-files,source,destination)
move-if-exists            = $(call test-exists,$1) && $(MV) '$(strip $1)' '$(strip $2)'

# Use RSYNC instead of simple CP to allow remote copying 
USE_RSYNC := $(if $(shell $(WHICH) $(RSYNC) 2>/dev/null),yes,)
define copy-helper
$(if $(USE_RSYNC),\
  $(RSYNC) $(RSYNC_FLAGS) '$(strip $1)' '$(strip $2)',\
  $(CP) '$(strip $1)' '$(strip $2)' )
endef

# Copy source to destination only if source exist 
define copy-if-exists  
$(call test-exists,$1) && $(call copy-helper,$1,$2) || \
  $(call echo-error, " '$1' does not exist and cannot be copied to '$2'")
endef

# Copy source to destination only if they are different
# $(call copy-if-different,source,destination)
copy-if-different  = $(call test-different,$1,$2) && $(call copy-helper,$1,$2)

# Move source to destination only if file 
move-if-different  = $(call test-different,$1,$2) && $(MV) '$(strip $1)' '$(strip $2)'

# Replace destination by source only if they are different, and remove source
# $(call replace-if-different-and-remove,source,destination)
define replace-if-different-and-remove
$(call test-different,$1,$2) && $(MV) '$(strip $1)' '$(strip $2)' || \
  $(call remove-files,'$(strip $1)')
endef

define replace-temporary-if-different-and-remove
 $(if $(KEEP_TEMP),:,$(call replace-if-different-and-remove, $1,$2))
endef

# Return value 1, or value 2 if value 1 is empty
# $(call get-default,<possibly empty arg>,<default value if empty>)
get-default  = $(if $1,$1,$2)
# Utility function for creating larger lists of files
# $(call concat-files,suffixes,[prefix])
concat-files  = $(foreach s,$1,$($(if $2,$2_,)files.$s))

# Utility function for obtaining all files not specified in $(neverclean)
# $(call cleanable-files,source destination file3 ...)
# Returns the list of files that is not in $(wildcard $(neverclean))
cleanable-files = $(filter-out $(wildcard $(neverclean)), $1)

# Find files
# $(call find-files,in_dir,with_pattern)
define find-files
$(FIND) $1 -name $2 -type f -prune  -print| $(SORT) | $(UNIQ)
endef

# Terminal color definitions
REAL_TPUT := $(if $(NO_COLOR),,$(shell $(WHICH) $(TPUT)))

# $(call get-term-code,codeinfo)
# e.g.,
# $(call get-term-code,setaf 0)
get-term-code = $(if $(REAL_TPUT),$(shell $(REAL_TPUT) $1),)

black   := $(call get-term-code,setaf 0)
red     := $(call get-term-code,setaf 1)
green   := $(call get-term-code,setaf 2)
yellow  := $(call get-term-code,setaf 3)
blue    := $(call get-term-code,setaf 4)
magenta := $(call get-term-code,setaf 5)
cyan    := $(call get-term-code,setaf 6)
white   := $(call get-term-code,setaf 7)
bg_black   := $(call get-term-code,setab 0)
bg_red     := $(call get-term-code,setab 1)
bg_green   := $(call get-term-code,setab 2)
bg_yellow  := $(call get-term-code,setab 3)
bg_blue    := $(call get-term-code,setab 4)
bg_magenta := $(call get-term-code,setab 5)
bg_cyan    := $(call get-term-code,setab 6)
bg_white   := $(call get-term-code,setab 7)
bold    := $(call get-term-code,bold)
uline   := $(call get-term-code,smul)
reset   := $(call get-term-code,sgr0)

#
# User-settable definitions
#
MSG_COLOR_WARNING   ?= magenta
MSG_COLOR_CLEAN     ?= bg_white magenta
MSG_COLOR_DISTCLEAN ?= bg_white magenta bold
MSG_COLOR_ERROR     ?= red
MSG_COLOR_INFO      ?= green
MSG_COLOR_UNDERFULL ?= magenta
MSG_COLOR_OVERFULL  ?= red bold
MSG_COLOR_PAGES     ?= bold
MSG_COLOR_BUILD     ?= blue
MSG_COLOR_RUN       ?= cyan
MSG_COLOR_GRAPHIC   ?= yellow
MSG_COLOR_DEP       ?= green
MSG_COLOR_SUCCESS   ?= green bold
MSG_COLOR_FAILURE   ?= red bold

# Gets the real color from a simple textual definition like those above
# $(call get-color,ALL_CAPS_COLOR_NAME)
# e.g., $(call get-color,WARNING)
get-color  = $(subst $(space),,$(foreach c,$(MSG_COLOR_$1),$($c)))

#
# STANDARD COLORS
#
C_BOLD      := $(bold)
C_WARNING   := $(call get-color,WARNING)
C_ERROR     := $(call get-color,ERROR)
C_INFO      := $(call get-color,INFO)
C_UNDERFULL := $(call get-color,UNDERFULL)
C_OVERFULL  := $(call get-color,OVERFULL)
C_PAGES     := $(call get-color,PAGES)
C_BUILD     := $(call get-color,BUILD)
C_RUN       := $(call get-color,RUN)
C_GRAPHIC   := $(call get-color,GRAPHIC)
C_DEP       := $(call get-color,DEP)
C_SUCCESS   := $(call get-color,SUCCESS)
C_FAILURE   := $(call get-color,FAILURE)
C_CLEAN     := $(call get-color,CLEAN)
C_DISTCLEAN := $(call get-color,DISTCLEAN)
C_RESET     := $(reset)
C_INDENT    := $(shell printf "%${i}s" '')

get_date_time   = $(DATE) +"%F %T"

# Display information about what is being done
echo_dt       = $(ECHO) -e "$(black)$(shell $(get_date_time))$(C_RESET)"
# $(call echo-build,<input file>,<output file>,[<run number>])
echo-build    = $(echo_dt) "\t$(C_BUILD)$(bold)==Build==$(C_RESET)$(C_BUILD)\t$1 --> $2$(if $3, ($3),)...$(C_RESET)"
echo-run      = $(echo_dt) "\t$(C_RUN)>>$(bold)Run $1$(C_RESET)$(C_RUN)$(if $2,\t$2 $(if $3,--> $3,),)...$(C_RESET)"
echo-copy     = $(echo_dt) "\t$(C_RUN)>>Copy $1$(if $2,\t$2 $(if $3,--> $3,),)...$(C_RESET)"
echo-graphic  = $(echo_dt) "$(C_GRAPHIC)++Gen. Fig.++ \t$1 --> $2$(C_RESET)"
echo-dep      = $(echo_dt) "$(C_DEP)**Deps**\t$1 --> $2$(C_RESET)"
echo-error    = $(echo_dt) "$(C_ERROR)**ERROR** $1 $(C_RESET)"
echo-failure  = $(echo_dt) "$(C_FAILURE)**FAILED** $1 $(C_RESET)"
echo-warning  = $(echo_dt) "$(C_WARNING)**WARNING** $1 $(C_RESET)"

# Display a list of something
# $(call echo-list,<values>)
echo-list  = for x in $1; do $(ECHO) "$$x"; done

define echo-end-target
$(call test-exists,$1)&& \
  $(echo_dt) "$(C_SUCCESS) Successfully generated $1$(C_RESET)" ||\
  $(echo_dt) "$(C_FAILURE) Fail to generate $1!!!$(C_RESET)" 
endef

#
# EXTERNAL PROGRAM DOCUMENTATION SCRIPT
#
# If cygpath is present, then we create a path-norm function that uses it,
# otherwise the function is just a no-op.  Issue 112 has details.
USE_CYGPATH := $(if $(shell $(WHICH) $(CYGPATH) 2>/dev/null),yes,)
define path-norm
$(if $(USE_CYGPATH),$(shell $(CYGPATH) -u "$1"),$1)
endef

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

WRITE_LOG ?=
# Log command to a log file
# $(call output-to-log,log)
define output-to-log
$(if $(WRITE_LOG),>> $1,>/dev/null)
endef

TEXLOG    ?=$(ROOTDIR)/$(TEXDIR)/build.log

# LaTeX invocations
#
# Note that we use
#
#  -recorder: generates .fls files for things that are input and output
#  -jobname: to make sure that .fls files are named after the source that created them
#  -file-line-error: to make sure that we have good line information for error output
#  -interaction=batchmode: so that we don't stop on errors (we'll parse logs for that)
#
# $(call run-latex,<tex file stem, e.g., $*>,[extra LaTeX args])
define run-latex
$(call echo-run,$(latex_build_program),$1); \
$(latex_build_program) -jobname='$(notdir $1)'\
  -interaction=batchmode -file-line-error \
  $(LATEX_OPTS) $(if $2,$2,) $1 $(call output-to-log,$(TEXLOG))
endef
# -output-directory='$(TEXDIR)' 

# Colorizes real, honest-to-goodness LaTeX errors that can't be overcome with
# recompilation.
#
# Note that we only ignore file not found errors for things that we know how to
# build, like graphics files.
#
# Also note that the output of this is piped through sed again to escape any
# backslashes that might have made it through.  This is to avoid sending things
# like "\right" to echo, which interprets \r as LF.  In bash, we could just do
# ${var//\\/\\\\}, but in other popular sh variants (like dash), this doesn't
# work.
#
# $(call colorize-latex-errors,<log file>)
define colorize-latex-errors
$(SED) \
-e '$${' \
-e '  /^$$/!{' \
-e '    H' \
-e '    s/.*//' \
-e '  }' \
-e '}' \
-e '/^$$/!{' \
-e '  H' \
-e '  d' \
-e '}' \
-e '/^$$/{' \
-e '  x' \
-e '  s/^\(\n\)\(.*\)/\2\1/' \
-e '}' \
-e '/^::P\(P\{1,\}\)::/{' \
-e '  s//::\1::/' \
-e '  G' \
-e '  h' \
-e '  d' \
-e '}' \
-e '/^::P::/{' \
-e '  s//::0::/' \
-e '  G' \
-e '}' \
-e 'b start' \
-e ':needonemore' \
-e 's/^/::P::/' \
-e 'G' \
-e 'h' \
-e 'd' \
-e ':needtwomore' \
-e 's/^/::PP::/' \
-e 'G' \
-e 'h' \
-e 'd' \
-e ':needthreemore' \
-e 's/^/::PPP::/' \
-e 'G' \
-e 'h' \
-e 'd' \
-e ':start' \
-e '/^! LaTeX Error: File /{' \
-e '  s/\n//g' \
-e '  b needtwomore' \
-e '}' \
-e 's/^[^[:cntrl:]:]*:[[:digit:]]\{1,\}:/!!! &/' \
-e 's/^\(.*\n\)\([^[:cntrl:]:]*:[[:digit:]]\{1,\}: .*\)/\1!!! \2/' \
-e '/^!!! .*[[:space:][:cntrl:]]LaTeX[[:space:][:cntrl:]]Error:[[:space:][:cntrl:]]*File /{' \
-e '  s/\n//g' \
-e '  b needonemore' \
-e '}' \
-e '/^::0::! LaTeX Error: File .*/{' \
-e '  /\n\n$$/{' \
-e '    s/^::0:://' \
-e '    b needonemore' \
-e '  }' \
-e '  s/^::0::! //' \
-e '  s/^\(.*not found.\).*Enter file name:.*\n\(.*[[:digit:]]\{1,\}\): Emergency stop.*/\2: \1/' \
-e '  b error' \
-e '}' \
-e '/^::0::!!! .*LaTeX Error: File .*/{' \
-e '  /\n\n$$/{' \
-e '    s/^::0:://' \
-e '    b needonemore' \
-e '  }' \
-e '  s/::0::!!! //' \
-e '  /File .*\.e\{0,1\}ps'"'"' not found/b skip' \
-e '  /could not locate.*any of these extensions:/{' \
-e '    b skip' \
-e '  }' \
-e '  s/\(not found\.\).*/\1/' \
-e '  s/^/!!! /' \
-e '  b error' \
-e '}' \
-e '/^\(.* LaTeX Error: Missing .begin.document.\.\).*/{' \
-e '  s//\1 --- Are you trying to build an include file?/' \
-e '  b error' \
-e '}' \
-e '/.*\(!!! .*Undefined control sequence\)[^[:cntrl:]]*\(.*\)/{' \
-e '  s//\1: \2/' \
-e '  s/\nl\.[[:digit:]][^[:cntrl:]]*\(\\[^\\[:cntrl:]]*\).*/\1/' \
-e '  b error' \
-e '}' \
-e '/^\(!pdfTeX error:.*\)s*/{' \
-e '  b error' \
-e '}' \
-e '/.*\(!!! .*\)/{' \
-e '  s//\1/' \
-e '  s/[[:cntrl:]]//' \
-e '  s/[[:cntrl:]]$$//' \
-e '  /Cannot determine size of graphic .*(no BoundingBox)/b skip' \
-e '  b error' \
-e '}' \
-e ':skip' \
-e 'd' \
-e ':error' \
-e 's/^!\(!! \)\{0,1\}\(.*\)/$(C_ERROR)\2$(C_RESET)/' \
-e 'p' \
-e 'd' \
'$1' | $(SED) -e 's/\\\\/\\\\\\\\/g'
endef


# Checks for the existence of a .aux file, and dies with an error message if it
# isn't there.  Note that we pass the file stem in, not the full filename,
# e.g., to check for foo.aux, we call it thus: $(call die-on-no-aux,foo)
#
# $(call die-on-no-aux,aux)
define die-on-no-aux
if $(call test-not-exists,$1.aux); then \
	$(call colorize-latex-errors,$1.log); \
	$(ECHO) "$(C_FAILURE)Error: failed to create $1.aux$(C_RESET)"; \
	exit 1; \
fi
endef

# Outputs all index files to stdout.  Arg 1 is the source file stem, arg 2 is
# the list of targets for the discovered dependency.
#
# $(call get-log-index,<log>,<target files>)
define get-log-index
$(SED) \
-e 's/^No file \(.*\.ind\)\.$$/TARGETS=\1/' \
-e 's/^No file \(.*\.[gn]ls\)\.$$/TARGETS=\1/' \
-e 's/[[:space:]]/\\&/g' \
-e '/^TARGETS=/{' \
-e '  h' \
-e '  s!^TARGETS=!$2: !p' \
-e '  g' \
-e '  s!^TARGETS=\(.*\)!\1: $1.tex!p' \
-e '}' \
-e 'd' \
'$1.log' | $(SORT) | $(UNIQ)
endef

# Get BUILD_BIB_STRATEGY from tex file
define get-bib-strategy
 $(shell $(EGREP) -q '^[^%]*\\usepackage\[.*backend=biber.*\]{biblatex}' $1 && $(ECHO) "biber" || $(ECHO) bibtex )
endef
# Colorize BibTeX output.
color_bib := \
$(SED) \
-e 's/^Warning--.*/$(C_WARNING)&$(C_RESET)/' \
-e 't' \
-e '/---/,/^.[^:]/{' \
-e '  H' \
-e '  /^.[^:]/{' \
-e '    x' \
-e '    s/\n\(.*\)/$(C_ERROR)\1$(C_RESET)/' \
-e '    p' \
-e '    s/.*//' \
-e '    h' \
-e '    d' \
-e '  }' \
-e '  d' \
-e '}' \
-e '/(.*error.*)/s//$(C_ERROR)&$(C_RESET)/' \
-e 'd'

# BibTeX invocations
# $(call run-bibtex,<tex >)
ifeq "$(strip $(TEX_BIB_STRATEGY))" "natbib"
BUILD_BIB_STRATEGY  := bibtex
ifeq "$(strip $(BUILD_BIB_STRATEGY))" "" # by default "bibtex"
run-bibtex  = $(call echo-run,$(BIBTEX),$1); $(BIBTEX) $1 | $(color_bib)
endif
endif

ifeq "$(strip $(BUILD_BIB_STRATEGY))" "biber"
run-bibtex  =  $(call echo-run,$(BIBER),$1); $(BIBER) $1 | $(color_bib)
endif
ifeq "$(strip $(BUILD_BIB_STRATEGY))" "" # by default "bibtex"
run-bibtex  = $(call echo-run,$(BIBTEX),$1); $(BIBTEX) $1 | $(color_bib)
endif

# Figures conversion 
#
# If they misspell gray, it should still work.
GRAY	?= $(call get-default,$(GREY),)

# Creation from  raw image, .jpg/.jpeg/.png/.tif/etc. files
#
# $(call convert-raw,<raw>,<out_fig>, $(GRAY))
define convert-raw
$(CONVERT) '$(strip $1)' $(if $(filter-out ,$3$(GRAY)),-type Grayscale,) '$(strip $2)'
endef

define get-inkscape-export
--export-$(strip $(if $(filter %.pdf,$1),pdf,$(if $(filter %.emf,$1),emf,$(if $(filter %.eps,$1),eps,\
$(if $(filter %.svg,$1),plain-svg,\
$(error "$(C_ERROR)Unsupported $(INKSCAPE) export '$1'$(C_RESET)"))))))
endef
INKSCAPE_FLAGS  +=--vacuum-defs --export-area-page
# Creation from  raw image, .jpg/.jpeg/.png/.tif/etc. files
#
# $(call convert-svg,<svg>,<out_fig>, $(GRAY))
define convert-svg
$(INKSCAPE) $(INKSCAPE_FLAGS) '$(strip $1)' $(call get-inkscape-export,$2)='$(strip $2)'
endef

###############################################################################
# VARIABLE DECLARATIONS
#

ifeq "$(strip $(BUILD_TEX_STRATEGY))" "pdflatex"
latex_build_program		    ?= $(PDFLATEX)
endif

ifeq "$(strip $(BUILD_TEX_STRATEGY))" "xelatex"
latex_build_program		    ?= $(XELATEX)
endif

ifeq "$(strip $(BUILD_TEX_STRATEGY))" "lualatex"
latex_build_program		    ?= $(LUALATEX)
endif

ifdef GLOSSARIES
PANDOC_XML_FLAGS  += -V glossary=$(wildcard $(GLOSSARIES_XML))
PANDOC_TEX_FLAGS  += -V glossary=$(notdir $(wildcard $(GLOSSARIES_TEX)))
endif
###############################################################################
# Files of interest / Sources files searched in INDIR

files_frontmatter ?= $(shell $(call find-files,$(INDIR),$(sources_frontmatter_pattern)))
files_mainmatter  ?= $(shell $(call find-files,$(INDIR),$(sources_mainmatter_pattern)))
files_backmatter  ?= $(shell $(call find-files,$(INDIR),$(sources_backmatter_pattern)))
files_sources     ?= $(files_frontmatter) $(files_mainmatter) $(files_backmatter)

files_noext       := $(basename $(files_sources))

# MDT/TEX files
files_mdt             := $(files_noext:$(INDIR)/%=$(MDTDIR)/%.mdt)
files_frontmatter_tex := $(files_frontmatter:$(INDIR)/%.md=$(TEXDIR)/%.tex)
files_mainmatter_tex  := $(files_mainmatter:$(INDIR)/%.md=$(TEXDIR)/%.tex)
files_mainmatter_mdt  := $(files_mainmatter:$(INDIR)/%.md=$(TEXDIR)/%.mdt)
files_backmatter_tex  := $(files_backmatter:$(INDIR)/%.md=$(TEXDIR)/%.tex)
files_tex             := $(files_frontmatter_tex) $(files_mainmatter_tex) $(files_backmatter_tex)
files_sty             := $(wildcard $(TEMPLATEDIR)/*.sty)
tex_sty               := $(files_sty:$(TEMPLATEDIR)/%=$(TEXDIR)/%)

# MDH files
files_mdh             := $(files_noext:$(INDIR)/%=$(MDHDIR)/%.mdh)
ifdef GLOSSARIES
files_mdh             := $(sort $(files_mdh) $(GLOSSARIES_MDH))
endif

# MDX files
files_mdx             := $(files_noext:$(INDIR)/%=$(MDXDIR)/%.mdx)

# SCSS/CSS files
files_scss        := $(filter-out $(SCSSDIR)/_%.scss,$(wildcard $(SCSSDIR)/*.scss))
files_css         := $(patsubst $(SCSSDIR)/%.scss,$(CSSDIR)/%.css,$(files_scss))
html_css          := $(filter %html.css,$(files_css))

## Figures
figures     != $(GREP) -sho '\($(FIGDIR)/[^{}\"\)]*\)' $(files_sources) | $(UNIQ)
mediafiles  := $(patsubst $(FIGDIR)/%,$(MEDIADIR)/%,$(figures))
fig_svg     := $(figures:%=$(OUTDIR)/%.svg)
fig_pdf     := $(figures:%=$(OUTDIR)/%.pdf)
fig_png     := $(figures:%=$(OUTDIR)/%.png)
fig_emf     := $(figures:%=$(OUTDIR)/%.emf)

################################################################################
# Dependancies
dir_deps  += $(OUTDIR) $(OUT_ASSETSDIR) $(MDHDIR) $(HTMLDIR) $(MDXDIR) $(XMLDIR) $(MDTDIR) $(OUT_FIGDIR) $(OUT_BIBDIR) $(CSSDIR)
base_deps += $(files_sources) $(METADATA) $(VARSDATA) $(PP_MACROS) $(OUT_ASSETSDIR) $(OUT_FIGDIR) 
bib_deps  += $(CSL) $(BIBFILES)
bibtex_deps+= $(BIBFILES) $(OUT_BIBDIR) $(BIBFILES:$(BIBDIR)/%=$(OUT_BIBDIR)/%)
mdt_deps  += $(MDTDIR) $(files_mdt) $(base_deps) $(PP_TEX_MACROS) $(bib_deps)
tex_deps  += $(TEXDIR) $(mdt_deps) $(TEMPLATEDIR)/template.latex $(tex_sty) \
  $(OUT_FONTDIR)/ $(fig_pdf) $(bibtex_deps)
pdf_deps  += 
ifdef GLOSSARIES
tex_deps += $(GLOSSARIES_TEX)
endif

css_deps  += $(SCSSINCS) $(foreach d,  $(SCSSINCS), $(wildcard $(d)/*.scss))
mdh_deps  += $(MDHDIR) $(base_deps) $(PP_HTML_MACROS) $(bib_deps) 
html_deps += $(HTMLDIR) $(OUT_FIGDIR) $(mdh_deps) $(SCSSINCS) $(html_css) \
  $(files_mdh) $(fig_svg)
ifdef GLOSSARIES
mdh_deps += $(PP_GLO_HTML)
endif
ifeq ($(BUILD_OUTPUT_MODE),multi)
html_deps += $(htmlmuli_temp)
endif

epub_deps += $(mdh_deps) $(TEMPLATEDIR)/template.epub3 \
  $(SCSSINCS) $(filter %epub.css,$(files_css)) $(fig_svg)
docx_deps += $(OUTDIR) $(mdh_deps) $(TEMPLATEDIR)/template.docx $(fig_emf)
odt_deps  += $(OUTDIR) $(mdh_deps) $(TEMPLATEDIR)/template.odt  $(fig_png)

mdx_deps  += $(MDXDIR) $(files_mdx) $(base_deps) $(PP_XML_MACROS)  $(bib_deps)
xml_deps  += $(XMLDIR) $(OUT_FIGDIR) $(mdx_deps) $(TEMPLATEDIR)/template.docbook5 \
  $(SCSSINCS) $(filter %docbook.css,$(files_css)) $(fig_svg)

ifdef GLOSSARIES
xml_deps    += $(PP_GLO_XML) $(GLOSSARIES_XML)
XSLT_FLAGS  += --stringparam glossary.collection $(GLOSSARIES_XML)
endif
################################################################################
# clean
clean_subdirs       += $(MDDIR) $(DATADIR) $(BIBDIR) $(FIGDIR) $(HTMLDIR) $(TEXDIR) 
clean_patterns      += *~ *.bak *.backup *.bck
clean_files         += $(foreach d,. $(clean_subdirs),$(addprefix $(d)/,$(clean_patterns))) $(BIB)
clean_css_files     += $(files_css)
clean_fig           += $(fig_svg) $(fig_pdf) $(fig_png) $(fig_emf)
clean_mdt_files     += $(files_mdt)

## Core latex/pdflatex auxiliary files:
clean_tex_aux_pattern+=*.aux *.cb *.cb2 *.fls *.fmt \
  *.fot *.lof *.log *.lol *.lot  *.out *.toc  *.upa *.upb\
  *.idx *.ind *.ilg *.glg *.glo *.gls *.nls *.nlo *.nlg \
  *.xmpdata
clean_tex_aux_files += $(addprefix $(TEXDIR)/,$(clean_tex_aux_pattern)))
## Bibliography auxiliary files (bibtex/biblatex/biber):
clean_tex_bib_pattern+=*.bbl *.bcf *.blg *-blx.aux *-blx.bib *.run.xml
clean_tex_bib_files += $(addprefix $(TEXDIR)/,$(clean_tex_bib_pattern)))

clean_tex_files     += $(files_tex)
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
	$(QUIET)$(ECHO) "files_scss  $(files_scss) "
################################################################################
# MAIN TARGETS
#

# HTML Output target
.PHONY: html
#.SECONDARY: $(HTMLDIR)/$(MAIN_DOC_BASENAME).html
html:$(html_deps)
ifeq ($(BUILD_OUTPUT_MODE), single)
	$(QUIET)$(MAKE) $(HTMLDIR)/$(MAIN_DOC_BASENAME).html
endif
ifeq ($(BUILD_OUTPUT_MODE),multi)
	$(QUIET)$(MAKE) run-jekyll;
endif
ifeq ($(BUILD_OUTPUT_MODE), html_db_chunk)
	$(QUIET)$(MAKE) xml-chunk
endif

html-deps:$(html_deps)
	$(QUIET)$(call echo-dep,html,$(html_deps))

ifeq ($(BUILD_OUTPUT_MODE), single)
html_deps += $(TEMPLATEDIR)/template.html5
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
	  $(call replace-temporary-if-different-and-remove,$@.sed,$@)
	$(call echo-end-target,$@)

# TeX/PDF Output target
.PHONY: pdf
#.SECONDARY: $(TEXDIR)/$(MAIN_DOC_BASENAME).pdf
pdf:$(OUTDIR)/$(MAIN_DOC_BASENAME).pdf 

define REMAKE_FLAGS
ROOTDIR='$(ROOTDIR)' \
files_frontmatter='$(files_frontmatter)' \
files_mainmatter='$(files_mainmatter)' \
files_backmatter='$(files_mainmatter)'
endef

$(OUTDIR)/$(MAIN_DOC_BASENAME).pdf:$(pdf_deps) \
  $(call path-norm,$(TEXDIR)/$(MAIN_DOC_BASENAME).pdf)
	$(QUIET)$(call echo-run,"Move",$<,$@)
	$(call replace-temporary-if-different-and-remove,$<,$@)
	$(call echo-end-target,$@)

$(TEXDIR)/$(MAIN_DOC_BASENAME).pdf:$(call path-norm,$(TEXDIR)/$(MAIN_DOC_BASENAME).tex)
	$(QUIET)$(call echo-build,$<,$@)
	$(QUIET)cd $(TEXDIR)&&$(MAKE) -f $(PWD)/$(this_file) $(REMAKE_FLAGS) \
	  BUILD_BIB_STRATEGY='$(strip $(call get-bib-strategy,$(TEXDIR)/$(MAIN_DOC_BASENAME).tex))' \
	"$(MAIN_DOC_BASENAME).pdf" && cd -
	$(call echo-end-target,$@)
#	$(QUIET)$(ECHO) "$(C_FAILURE) build of $@ not yet implemented$(C_RESET)"

.SECONDARY: $(TEXDIR)/$(MAIN_DOC_BASENAME).pdf \
  $(TEXDIR)/$(MAIN_DOC_BASENAME).tex 

tex: $(TEXDIR)/$(MAIN_DOC_BASENAME).tex

ifeq ($(BUILD_OUTPUT_MODE), single)
$(TEXDIR)/$(MAIN_DOC_BASENAME).tex: $(files_frontmatter_tex) $(files_backmatter_tex) $(tex_deps)
	$(QUIET)$(call echo-build,LaTeX files,$@)
	$(QUIET)$(call echo-run,$(PANDOC),...,$@)
	$(QUIET)$(MKDIR) $(TEXDIR)
	$(QUIET)$(PANDOC) -f markdown$(PANDOC_MDEXT) \
	  $(PANDOC_FLAGS) $(VARSDATA) $(PANDOC_TEX_FLAGS)\
	  $(foreach f,$(files_frontmatter_tex),--include-before-body=$(f)) \
    $(foreach f,$(files_backmatter_tex),--include-after-body=$(f)) \
	  $(files_mainmatter_mdt) -t latex -o $@
	$(call echo-end-target,$@)
endif
ifeq ($(BUILD_OUTPUT_MODE),multi)
$(TEXDIR)/$(MAIN_DOC_BASENAME).tex:$(files_tex) $(tex_deps) 
	$(QUIET)$(call echo-build,LaTeX files,$@)
	$(call echo-list,$(foreach f,$(files_mainmatter_tex),\\include{$(notdir $(basename $(f)))})) >$(TEXDIR)/$(MAIN_DOC_BASENAME)_inc
	$(QUIET)$(call echo-run,$(PANDOC),...,$@)
	$(PANDOC) $(PANDOC_FLAGS) $(VARSDATA) $(PANDOC_TEX_FLAGS)\
	  $(foreach f,$(files_frontmatter_tex),-V frontmatter=$(notdir $(basename $(f))))\
	  $(foreach f,$(files_backmatter_tex),-V backmatter=$(notdir $(basename $(f)))) \
	  $(TEXDIR)/$(MAIN_DOC_BASENAME)_inc -t latex -o $(TEXDIR)/$(MAIN_DOC_BASENAME).tex
	$(call remove-temporary-files,$(TEXDIR)/$(MAIN_DOC_BASENAME)_inc)
	$(call echo-end-target,$@)
endif

# Merge all bibliography in BIB
#
.PHONY: biblio $(BIB)
.SECONDARY:$(BIB)
biblio:$(BIB)
$(BIB):$(BIBFILES)
	$(QUIET)$(call echo-build,"Merge",$(BIBFILES),$@)
	$(QUIET)$(MKDIR) $(OUT_BIBDIR)
	$(QUIET)$(CAT) $(BIBFILES) > $(BIB)

$(OUT_BIBDIR)/%.bib:$(BIBDIR)/%.bib
	$(QUIET)$(call echo-copy,bib,$<,$@)	
	$(QUIET)$(call copy-if-exists,$<,$@)

$(ROOTDIR)/$(OUT_BIBDIR)/%.bib:$(ROOTDIR)/$(BIBDIR)/%.bib
	$(QUIET)$(call echo-copy,bib+,$<,$@)	
	$(QUIET)$(call copy-if-exists,$<,$@)
#########################
# Intermediate MDT rules for LaTeX/PDF 
# Keep the generated .tex files around for debugging if needed.
.SECONDARY: $(files_tex)
	
# $(call test-run-again,<source stem>)
define test-run-again
$(EGREP) '^(.*Rerun .*|No file $1\.[^.]+\.)$$' $1.log \
| $(EGREP) -q -v '^(Package: rerunfilecheck.*Rerun checks for auxiliary files.*)$$'
endef

# Build pdf from LaTeX files:

%.pdf:%.tex %.bbl %.aux
	$(QUIET)fatal=`$(call colorize-latex-errors,$*.log)`; \
	if [ x"$$fatal" != x"" ]; then \
		$(ECHO) "$$fatal"; \
		exit 1; \
	fi; \
	for i in 2 3 4; do \
		if $(call test-run-again,$*); then \
	    $(echo_dt) "$(C_INFO)Need to re-run LaTeX...$(C_RESET)";\
			$(call echo-build,$<,$*.pdf,$$i); \
			$(call run-latex,$*); \
		else \
			break; \
    fi; \
  done
  
#biblio
ifeq "$(strip $(TEX_BIB_STRATEGY))" "natbib"
%.bbl:%.aux
	$(QUIET)$(if $(filter %.bib,$^);\
		$(call echo-build,$(filter %.bib,$?) $*.aux,$@); \
		$(call run-bibtex,$*); \
	  $(call echo-end-target,$@); \
	) 
endif
ifeq "$(strip $(TEX_BIB_STRATEGY))" "biblatex"
%.bbl:%.bcf %.aux
	$(QUIET)$(call echo-build,$<,$@); \
	$(call run-bibtex,$<,$@,$*.bcf) ;\
	$(call echo-end-target,$@) 
endif

%.aux %.bcf %.fls:%.tex
	$(QUIET)$(call echo-build,$<,$*.pdf,1);\
	$(echo_dt) "$(C_INFO)Create/Update $*.aux $*.bcf and $*.fls$(C_RESET)";\
	$(call run-latex,$*,-recorder)|| $(sh_true); \
	$(call die-on-no-aux,$*) ;\
	fatal=`$(call colorize-latex-errors,$*.log)`; \
	if [ x"$$fatal" != x"" ]; then \
		$(ECHO) "$$fatal"; \
		exit 1; \
	fi;

#.INTERMEDIATE: $(files_mdt)
$(MDTDIR)/%.mdt:$(MDDIR)/%.md
	$(QUIET)$(call echo-run,$(PANDOC),$<,$@)
	$(QUIET)$(MKDIR) $(MDTDIR)
	$(PP) $(PP_FLAGS) -DLATEX=1 -import=$(PP_MACROS) $< | \
	  $(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) \
	  $(PANDOC_MDT_FLAGS) -t markdown$(PANDOC_MDEXT) -o "$@"
	$(QUIET)$(SED)  -e 's/}\s*\\cite{/,/g' -e 's/}\s*\\cref{/,/g'  < $@ > $@.sed
	$(call replace-temporary-if-different-and-remove,$@.sed,$@)

%.tex:%.mdt 
	$(QUIET)$(call echo-run,$(PANDOC),$<,$@)
	$(QUIET)$(PANDOC) $< $(METADATA) $(PANDOC_FLAGS)  -t latex -o $@
  
$(TEXDIR)/%.sty:$(TEMPLATEDIR)/%.sty
	$(QUIET)$(call echo-copy,sty,$<,$@)
	$(QUIET)$(call copy-if-exists,$<,$@)

$(OUT_FONTDIR)/:$(FONTDIR)/
	$(QUIET)$(call echo-copy,Fonts,$<,$@)
	$(QUIET)$(MKDIR) $(OUT_FONTDIR)
	$(QUIET)$(call copy-if-exists,$<,$@)

# Intermediate MDH rules for html/epub/docx/odt 
#.INTERMEDIATE: $(files_mdh)
$(MDHDIR)/%.mdh:$(MDDIR)/%.md
	$(QUIET)$(call echo-run,$(PANDOC),$<,$@)
	$(QUIET)$(MKDIR) $(MDHDIR)
	$(PP) $(PP_FLAGS) -DHTML=1 -import=$(PP_MACROS) -import=$(PP_GLO_HTML) $< | \
	  $(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) -t markdown$(PANDOC_MDEXT) -o "$@"
	$(QUIET)$(SED)  -e 's/\]\s*\[@/; @/g' < $@ > $@.sed && \
	  $(call replace-temporary-if-different-and-remove,$@.sed,$@)
	  
# Intermediate MDX rules for xml/docbook
#.INTERMEDIATE: $(files_mdx)
$(MDXDIR)/%.mdx:$(MDDIR)/%.md
	$(QUIET)$(call echo-run,$(PANDOC),$<,$@)
	$(QUIET)$(MKDIR) $(MDXDIR)
	$(PP) $(PP_FLAGS) -DXML=1 -import=$(PP_MACROS) -import=$(PP_GLO_XML) $< | \
	  $(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) -t markdown$(PANDOC_MDEXT) -o "$@"
	$(QUIET)$(SED)  -e 's/\]\s*\[@/; @/g' < $@ > $@.sed && \
	  $(call replace-temporary-if-different-and-remove,$@.sed,$@)
	  
################################################################################
#  Intermediate Glossaries rules
$(GLOSSARIES_TEX):$(GLOSSARIES) $(PP_TEX_MACROS) $(PP_MACROS)
	$(QUIET)$(call echo-run,$(PP),$<,$@)
	$(PP) $(PP_FLAGS) -DLATEX=1 -import=$(PP_MACROS) $(GLOSSARIES) > $(GLOSSARIES_TEX)

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
$(NODEDIR)/bootstrap/scss: $(NODEDIR)/bootstrap/
	$(QUIET)$(ECHO) "$(C_INFO) Bootstrap is in '$(NODEDIR)/bootstrap/' folder$(C_RESET)"
	$(QUIET)$(NPM) update bootstrap

$(SASS):$(NODEDIR)/sass
	$(QUIET)$(ECHO) "$(C_INFO) SASS is  in '$(NODEDIR)/sass'$(C_RESET)"

# get bootstrap and its dependancies
#bootstrap:$(NODEDIR)/bootstrap/
#	$(QUIET)$(ECHO) "$(C_INFO) Bootstrap is in '$(NODEDIR)/bootstrap'$(C_RESET)"
################################################################################
#  Intermediate Figures rules
# Converts svg files into .eps files
#
.PHONY: svg
svg:$(fig_svg) $(OUT_FIGDIR)
$(OUT_FIGDIR)/%.svg:$(MEDIADIR)/%.svg
	$(QUIET)$(call echo-graphic,$^,$<,$@)
	$(QUIET)$(call convert-svg,$<,$@)
ifeq "$(if $(shell $(WHICH) $(SVGO) 2>/dev/null),1,)" "1"
	$(QUIET)$(SVGO) --enable={cleanupIDs,collapseGroups,removeUnusedNS,removeUselessStrokeAndFill,removeUselessDefs,removeComments,removeMetadata,removeEmptyAttrs,removeEmptyContainers} $@
endif
ifeq "$(if $(shell $(WHICH) $(SCOUR) 2>/dev/null),1,)" "1"
	$(QUIET)$(SCOUR) --enable-viewboxing --enable-id-stripping \
		--enable-comment-stripping --shorten-ids --indent=none \
		-i $@ -o $@o 
	 $(call replace-temporary-if-different-and-remove,$@o,$@)
endif

$(OUT_FIGDIR)/%.svg:$(MEDIADIR)/%.png
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-raw,$<,$@,$(GRAY))
$(OUT_FIGDIR)/%.svg:$(MEDIADIR)/%.jpg
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-raw,$<,$@,$(GRAY))
$(OUT_FIGDIR)/%.svg:$(MEDIADIR)/%.tif
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-raw,$<,$@,$(GRAY))

$(OUT_FIGDIR)/%.pdf:$(MEDIADIR)/%.svg
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-svg,$<,$@)
	
$(OUT_FIGDIR)/%.pdf:$(OUT_FIGDIR)/%.svg
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-svg,$<,$@)
	
$(OUT_FIGDIR)/%.emf:$(MEDIADIR)/%.svg
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-svg,$<,$@)
	
$(OUT_FIGDIR)/%.emf:$(OUT_FIGDIR)/%.svg
	$(QUIET)$(call echo-graphic,$^,$@)
	$(QUIET)$(call convert-svg,$<,$@)

################################################################################
# PREPARE TARGETS
#
dir_prep += $(sort $(dir_deps))
ifeq ($(BUILD_OUTPUT_MODE),multi)
dir_prep += $(htmlmuli_temp)
endif
.PHONY: prepare dirs $(dir_prep)
prepare: dirs $(prepare_targets)
dirs: $(dir_prep)
$(dir_prep):
	$(QUIET)$(call echo-run,Make dir,$@); $(MKDIR) $@

# Install a npm module
$(NODEDIR)/%/:
	$(QUIET)$(ECHO) "$(C_INFO) $* will be installed in the local folder$(C_RESET)"
	$(QUIET)$(call echo-run,$(NPM)++,$*,$@)
	$(QUIET)$(NPM) install $*
	$(QUIET)$(ECHO) "$(C_INFO) $* now in '$@'$(C_RESET)"

ifeq ($(BUILD_OUTPUT_MODE),multi)
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
	$(QUIET)$(call echo-copy,Jekyll,$<,$@)
	$(QUIET)$(call clean-files,$(htmlmuli_temp)/.synced)
	$(QUIET)$(call copy-helper,$(TEMPLATEJEKYLLDIR)/,$(htmlmuli_temp)/)\
	&& $(TOUCH) $(htmlmuli_temp)/.synced

htmlmulti_dep   += $(htmlmuli_temp)/metadata.yml $(htmlmuli_temp)/variables.yml

$(htmlmuli_temp)/metadata.yml: $(METADATA)
	$(QUIET)$(call echo-copy, metadata,$<,$@)
	$(QUIET)$(call copy-if-exists,$(METADATA),$(htmlmuli_temp)/)

$(htmlmuli_temp)/variables.yml: $(VARSDATA)
	$(QUIET)$(call echo-copy,vars,$<,$@)
	$(QUIET)$(call copy-if-exists,$(VARSDATA),$(htmlmuli_temp)/_data/)

htmlmulti_csl   := $(htmlmuli_temp)/assets/bib/$(notdir $(CSL))
htmlmulti_bib   := $(htmlmuli_temp)/assets/bib/$(notdir $(BIB))
htmlmulti_dep   += $(htmlmulti_csl) $(htmlmulti_bib)

$(htmlmulti_csl):$(CSL)
	$(QUIET)$(call echo-copy,csl,$<,$@)
	$(QUIET)$(call copy-if-exists,$(CSL),$(htmlmuli_temp)/assets/bib/)

$(htmlmulti_bib):$(BIB) | $(BIBFILES)
	$(QUIET)$(call echo-copy,bib,$<,$@)
	$(QUIET)$(call copy-if-exists,$(BIB),$(htmlmuli_temp)/assets/bib/)

htmlmulti_css   := $(html_css:$(CSSDIR)/%.css=$(htmlmuli_temp)/assets/css/%.css)
htmlmulti_dep   += $(htmlmulti_css)
$(htmlmuli_temp)/assets/css/%.css: $(CSSDIR)/%.css
	$(QUIET)$(call echo-copy,css,$<,$@)
	$(QUIET)$(call copy-if-exists,$<,$@)

htmlmulti_fig   := $(fig_$(default_image_extension):$(OUT_FIGDIR)/%.$(default_image_extension)=$(htmlmuli_temp)/assets/fig/%.$(default_image_extension))
htmlmulti_dep   += $(htmlmulti_fig)
$(htmlmuli_temp)/assets/fig/%: $(OUT_FIGDIR)/%
	$(QUIET)$(call echo-copy,fig,$<,$@)
	$(QUIET)$(call copy-if-exists,$<,$@)
	
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
	$(QUIET)$(call echo-copy,mdh,$<,$@)
	$(QUIET)$(call copy-if-exists,$<,$@)

$(htmlmuli_temp)/$(MAIN_DOC_BASENAME).mdh: $(htmlmulti_mdh) $(htmlmuli_temp)/variables.yml 
	$(QUIET)$(call echo-run,"Prepare Markdown for jekyll [1]",:,$@)
	$(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) $(PANDOC_MDH_FLAGS) -t markdown$(PANDOC_MDEXT) $(htmlmulti_mdh) -o "$@"

$(htmlmuli_temp)/%.md_tmp:$(htmlmuli_temp)/%.mdh
	$(QUIET)$(call echo-run,"Prepare Markdown for jekyll [2]",$<,$@)
	$(PANDOC) -f markdown$(PANDOC_MDEXT) $(PANDOC_FLAGS) $(PANDOC_MDH_FLAGS) -t markdown$(PANDOC_MDEXT) $< -o "$@"

$(htmlmuli_temp)/%.md:$(htmlmuli_temp)/%.md_tmp $(htmlmuli_temp)/%.mdh
	$(QUIET)$(call echo-run,"Prepare Markdown for jekyll [3]",$<,$@)
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
	  $(call replace-temporary-if-different-and-remove	,$@.sed,$@); \
	  done
#	$(call remove-temporary-files,$<) 

#	$(ECHO) " donot remove $< ..."
#sed -e 's/^## \(.*\)[[:space:]]*{#\(.*\)}/section: [\1,\2]/g'
#	$(SED) -e 's/\[@\([^]]*\)\]/{% cite \1%}/g' < $@ > $@.sed && \
#	  $(call replace-temporary-if-different-and-remove	,$@.sed,$@)

#	$(QUIET)$(SED)  -e 's/\]\s*\[@/; @/g' < $@ > $@.sed && 

tt:
	$(QUIET)$(ECHO) "$(htmlmulti_dep)"
	
.PHONY: run-jekyll 
run-jekyll: $(htmlmulti_dep)  | $(htmlmuli_temp)/.jekyll_installed 
	$(QUIET)$(call echo-build,$(JEKYLL),htmlmulti)
	$(call remove-temporary-files,$(htmlmulti_mdh)) 
	$(call remove-temporary-files,$(htmlmuli_temp)/$(MAIN_DOC_BASENAME).mdh) 
	$(QUIET)cd $(htmlmuli_temp) && $(REAL_JEKYLL) build -d ../../$(CHUNKDIR) && cd -

serve-jekyll:$(htmlmulti_dep)|$(htmlmuli_temp)/.jekyll_installed
	$(QUIET)$(ECHO) -e "\n########################\n"
	$(QUIET)$(ECHO) "$(C_WARNING) Jekyll serve watch only already generated documents in '$(htmlmuli_temp)'$(C_RESET)"
	$(QUIET)$(ECHO) "$(C_WARNING) Live modification of the sources in $(INDIR) are not watched!$(C_RESET)"
	$(QUIET)$(call echo-build,$(JEKYLL),htmlmulti)
	$(QUIET)cd $(htmlmuli_temp) && $(REAL_JEKYLL) serve && cd -
#
endif
################################################################################
# CLEAN TARGETS
#
.PHONY: clean-all clean-html
clean: clean-files clean-aux clean-bib clean-mdt clean-mdh clean-css clean-fig ;
clean-files:
	$(QUIET)$(echo_dt) "$(C_WARNING) Cleaning unnecessary documents...$(C_RESET)"
	$(call clean-files,$(clean_files))

clean-aux:
	$(QUIET)$(echo_dt) "$(C_WARNING) Cleaning LaTeX intermediates...$(C_RESET)"
	$(call clean-files,$(clean_tex_aux_files))
clean-bib:
	$(QUIET)$(echo_dt) "$(C_WARNING) Cleaning Bib intermediates...$(C_RESET)"
	$(call clean-files,$(clean_tex_bib_files))
	
clean-mdt:
	$(QUIET)$(echo_dt) "$(C_WARNING) Cleaning Markdown/Html intermediates...$(C_RESET)"
	$(call clean-files,$(clean_mdt_files))
	
clean-tex: clean-aux clean-files
	$(QUIET)$(echo_dt) "$(C_WARNING) Cleaning LaTeX intermediates...$(C_RESET)"
	$(call clean-files,$(clean_tex_files))

clean-mdh:
	$(QUIET)$(echo_dt) "$(C_WARNING) Cleaning Markdown/Html intermediates...$(C_RESET)"
	$(call clean-files,$(clean_mdh_files))

clean-html: clean-files clean-css
	$(QUIET)$(echo_dt) "$(C_WARNING) Clean HTML $(clean_html_files)...$(C_RESET)"
	$(call clean-files,$(clean_html_files))
	
clean-css:
	$(QUIET)$(echo_dt) "$(C_WARNING) Clean CSS intermediates...$(C_RESET)"
	$(call clean-files,$(clean_css_files))

clean-fig:
	$(QUIET)$(echo_dt) "$(C_WARNING) Clean figures intermediates...$(C_RESET)"
	$(call clean-files,$(clean_fig))

# DISTCLEAN TARGETS
# Remove all intermediate
.PHONY: distclean
distclean: clean
	$(QUIET)$(echo_dt) "$(C_ERROR) Distclean unnecessary subdirs:'$(distclean_subdirs)'$(C_RESET)"
	$(QUIET)$(call clean-files,$(distclean_files))
	$(QUIET)$(RM) -r $(distclean_subdirs)

# make a compressed archive
# $(call make_archive,<compressed_file>,dir)
define make_archive
$(ZIP) -r -T -q $1 $2
endef
#

.PHONY:dist
dist: distclean archive
archive:zip;
zip:
	$(QUIET)$(call echo-run,$(ZIP),$(DISTNAME),../$(TODAY)_$(MAIN_DOC_BASENAME).zip)
	$(call make_archive,../$(TODAY)_$(MAIN_DOC_BASENAME).zip,*)

tbz:
	$(QUIET)$(call echo-run,$(TAR),$(DISTNAME),../$(TODAY)_$(MAIN_DOC_BASENAME).tbz)
	cd .. &&$(TAR) cjf $(TODAY)_$(MAIN_DOC_BASENAME).tbz $(DISTNAME) && cd -
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
		'$$(NODEDIR)'*)\
		  node=`$(ECHO) $$p| $(SED) -e 's|\$$(NODEDIR)|$(NODEDIR)|g'`;\
		  np=`basename $$node`;\
		   $(ECHO) -n "$$np:$$spaces" | $(SED) -e 's/^\(.\{0,20\}\).*$$/\1/'; \
			loc=`$(WHICH) $$node`; \
			if [ x"$$?" = x"0" ]; then \
				$(ECHO) "$(C_SUCCESS)Found:$(C_RESET) $$loc"; \
			else \
				$(ECHO) "$(C_FAILURE)Not Found$(C_RESET)"; \
			fi; \
			;; \
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

VERS_FILE=$(ROOTDIR)/VERSION
VERSION !=$(CAT) $(VERS_FILE)
version: VERSION
	$(QUIET)$(echo_dt) "version: v$(VERSION)"
	$(SED) -i 's/"version": .*/"version": "$(VERSION)",/' package.json
	$(SED) -i 's/version: .*/version: $(VERSION)/' $(VARSDATA)
#
# HELP TEXT
#

define help_text
% MAKE(1) Make for pandoc-df-thesis-template 
% D. Folio
% November 26, 2018

# NAME

make - make utility to build a pandoc-df-thesis-template dissertation 

 Generates a number of possible output files from Pandoc document and its
 various dependencies. 

# SYNOPSIS

make [GRAY=1] [VERBOSE=1] [SHELL_DEBUG=1] <target(s)>

# DESCRIPTION

This Makefile allows to generate  pandoc-df-thesis-template dissertation in
various output format, and its necessary materials. 

Once you have edited the `Makefile` (optional), the `_data/variables.yml` (advised), and  written some elements in the sources directory:  `_md/`, run this simple shell command:

  make 

# STANDARD TARGETS

all
:  Make default targets (defined with `BUILD_DEFAULT_TARGETS`), e.g.: html, pdf

pdf
:  Build the PDF output document from LaTeX generated files.

     **Note**: the PDF is generated using the `BUILD_TEX_STRATEGY`, set with one of: lualatex, pdflatex or xelatex

html
:  Build the HTML(5) output document:

   -  If `BUILD_OUTPUT_MODE=single`: a single HTML(5) document are generated using Pandoc.
   -  If `BUILD_OUTPUT_MODE=htmlmulti`: multiple HTML(5) documents are  generated using Jekyll.

docx
:  Build the MS Word output document

odt
:  Build the LibreOffice/OpenOffice output document

epub
:  Build the EPUB(v3) output document

xml
:  Build the DocBook(v5) output document

clean
:  Remove ALL generated files, leaving only sources and "important" intermediates 
   intact. This will *always* skip files mentioned in the "neverclean" variable,
   either in this file or specified in Makefile.ini, e.g.:
   
   ```
     neverclean := *.pdf *.svg
   ```

distclean
:  *Remove ALL generated files!!!* (e.g. 'build/' is removed!!!).


dist
:  Create an archive file for the dissertation.

    - **Note 1**: the *distclean* target are called before creating the archive! 
    - **Note 2**: the archive are place in the parent folder with the following 
      format: `<TODAY>_<MAIN_DOC_BASENAME>.zip`

# STANDARD OPTIONS:

VERBOSE
:  This turns off all @ prefixes for commands invoked by make.  Thus,
    you get to see all of the gory details of what is going on.

SHELL_DEBUG
:  This enables the -x option for sh, meaning that everything it does is
    echoed to stderr.  This is particularly useful for debugging
    what is going on in $$(shell ...) invocations.  One of my favorite
    debugging tricks is to do this:

    make -d SHELL_DEBUG=1 VERBOSE=1 2>&1 | less

KEEP_TEMP
:  When set, this allows .make and other temporary files to stick around
    long enough to do some debugging.  This can be useful when trying to
    figure out why gnuplot is not doing the right things, for example.

# Minor Issue

In case of troubleshooting, first hit:

```{sh}
make _check_programs
```

and look for "Not Found" programs: some of them are mandatory!
 
# See Also

- The [GitHub](https//github.com) repository: <https://github.com/dfolio/pandoc-df-thesis-template>
- The [GitHub](https//github.com) wiki: <https://github.com/dfolio/pandoc-df-thesis-template/wiki>


endef

#
# HELP TARGETS
#
export help_text
.PHONY: help
help:
	$(ECHO) "$$help_text" | $(PANDOC) -s  -f markdown -t man | man -l -

#$(call path-norm,)
.SECONDEXPANSION:
$(MAIN_DOC_BASENAME).aux $(MAIN_DOC_BASENAME).bbl:$(BIBFILES:$(BIBDIR)/%=$(ROOTDIR)/$(OUT_BIBDIR)/%)


