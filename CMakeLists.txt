################################################################################
## Copyright (c) 2018 David Folio
## All rights reserved.
################################################################################
## License : CC-by-4.0             (See LICENSE filefor the full license text) #
################################################################################
PROJECT(PDFTT) # Pandoc-DF-Thesis-Template
################################################################################
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
INCLUDE(Pandoc-thesis-template)
################################################################################
# DEFAULT DIR
SET(PROJECT_ASSETS_DIR      "${PROJECT_BINARY_DIR}/assets")
SET(PROJECT_BIB_DIR         "${PROJECT_ASSETS_DIR}/assets/bib")
SET(PROJECT_MEDIA_DIR       "${PROJECT_ASSETS_DIR}/assets/bib")
SET(PROJECT_DATA_DIR        "${PROJECT_BINARY_DIR}/_data")
SET(PROJECT_TEMPLATE_DIR    "${PROJECT_BINARY_DIR}/_layouts")
SET(PROJECT_SASS_DIR        "${PROJECT_BINARY_DIR}/_sass")
## OUTPUTS
################################################################################
# Option management ############################################################
################################################################################
OPTION(PROJECT_MD_DIR       "The (modified) markdown sources of the dissertation"
                            "${PROJECT_BINARY_DIR}/_md")

SET(PROJECT_HTML_DIR        "HTML output dir"   "${PROJECT_BINARY_DIR}/_html")
SET(PROJECT_TEX_DIR         "LaTeX output dir"  "${PROJECT_BINARY_DIR}/_tex")
SET(PROJECT_DB_DIR          "Docbook output dir" "${PROJECT_BINARY_DIR}/_docbook")
# Base files ###################################################################
OPTION(PROJECT_METADATA     "Metadata for Pandoc and its filter (e.g. pandoc-citeproc and pandoc-crossref)"
                            "${PROJECT_ASSETS_DIR}/metadata.yml")
OPTION(PROJECT_VARSDATA     "Variables definition used by Pandoc templates"
                            "${PROJECT_ASSETS_DIR}/variables.yml")
OPTION(PROJECT_GLOSSARIES   "Where terms, glossaries, acronyms... are defined. Leave blank if glossaries is not used."
"${PROJECT_ASSETS_DIR}/glossaries.pp")
OPTION(PROJECT_CSL          "The CSL bibliography style"
                            "${PROJECT_TEMPLATE_DIR}/Thesis-ieee-style.csl")
OPTION(PROJECT_XSL          "The XSL stylesheets for docbook. Leave blank to disable docbook outputs."
                            "${PROJECT_TEMPLATE_DIR}/xsl/html5.xsl")
