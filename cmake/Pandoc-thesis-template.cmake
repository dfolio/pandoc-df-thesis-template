################################################################################
## Copyright (c) 2018 David Folio
## All rights reserved.
################################################################################
## License : CC-by-4.0             (See LICENSE filefor the full license text) #
################################################################################
# Version number.  An even minor number corresponds to releases.
SET(PROJECT_VERSION_MAJOR "2018")
SET(PROJECT_VERSION_MINOR "3")
SET(PROJECT_VERSION_PATCH "1")
SET(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")
SET(PROJECT_DESCRIPTION "This repository provides the D. Folio template for writing a thesis dissertation using Pandoc, <http://pandoc.org>.")
SET(PROJECT_URL "<not yet>")
################################################################################
CMAKE_MINIMUM_REQUIRED(VERSION 2.6)
MARK_AS_ADVANCED(CMAKE_BACKWARDS_COMPATIBILITY)
#Set LANG to C
SET(MESSAGES_ENV_VAR  $ENV{LC_MESSAGES})
SET(CTYPE_ENV_VAR     $ENV{LC_CTYPE})
SET(ENV{LC_MESSAGES} "C")
SET(ENV{LC_CTYPE}    "C")
################################################################################
# DEFAULT DIR
SET(PROJECT_ASSETS_DIR      "${PROJECT_BINARY_DIR}/assets")
SET(PROJECT_BIB_DIR         "${PROJECT_ASSETS_DIR}/assets/bib")
SET(PROJECT_MEDIA_DIR       "${PROJECT_ASSETS_DIR}/assets/bib")
SET(PROJECT_DATA_DIR        "${PROJECT_BINARY_DIR}/_data")
SET(PROJECT_TEMPLATE_DIR    "${PROJECT_BINARY_DIR}/_layouts")
SET(PROJECT_MD_DIR          "${PROJECT_BINARY_DIR}/_md")
SET(PROJECT_SASS_DIR        "${PROJECT_BINARY_DIR}/_sass")

SET(PROJECT_HTML_DIR        "${PROJECT_BINARY_DIR}/_html")
SET(PROJECT_TEX_DIR         "${PROJECT_BINARY_DIR}/_tex")
SET(PROJECT_DB_DIR         "${PROJECT_BINARY_DIR}/_docbook")
