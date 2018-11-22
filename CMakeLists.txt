################################################################################
## Copyright (c) 2018 David Folio
## All rights reserved.
################################################################################
## License : CC-by-4.0            (See LICENSE file for the full license text) #
################################################################################
PROJECT(PDFTT NONE) # Pandoc-DF-Thesis-Template
################################################################################
## Define the main document basename
SET(PROJECT_DOCNAME       "my_thesis" CACHE STRING "Output document basename" )
################################################################################
CMAKE_MINIMUM_REQUIRED(VERSION 3.12)
SET(PROJECT_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
# make sure our own modules are found
SET(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${PROJECT_CMAKE_DIR})
#include_directories("${CMAKE_CURRENT_SOURCE_DIR}/cmake")
INCLUDE(PDFTTmacros)






################################################################################
# Notice: file(GLOB_RECURSE ...) should be avoided below (see CMake documentaion)
file(GLOB_RECURSE IN_MD_BEFORE_FILES "${PROJECT_MD_DIR}/0*.md")
list(TRANSFORM IN_MD_BEFORE_FILES  REPLACE "\\.md"  "" OUTPUT_VARIABLE IN_BEFORE_FILES)
file(GLOB_RECURSE IN_MD_BODY_FILES "${PROJECT_MD_DIR}/[1-8]*.md")
list(TRANSFORM IN_MD_BODY_FILES  REPLACE "\\.md"  "" OUTPUT_VARIABLE IN_BODY_FILES)
file(GLOB_RECURSE IN_MD_AFTER_FILES "${PROJECT_MD_DIR}/9*.md")
list(TRANSFORM IN_MD_AFTER_FILES  REPLACE "\\.md"  "" OUTPUT_VARIABLE IN_AFTER_FILES)
SET(IN_MD_FILES ${IN_MD_BEFORE_FILES} ${IN_MD_BODY_FILES} ${IN_MD_AFTER_FILES})
SET(INFILES ${IN_BEFORE_FILES} ${IN_BODY_FILES} ${IN_AFTER_FILES})
################################################################################
file(GLOB_RECURSE PPFILES "${PROJECT_PP_DIR}/*.pp")
################################################################################  
# Figures
grep_func2(
  "^[^%]*.*\\(${PROJECT_FIG_DIR}\/.*\\)"
  "\((${PROJECT_FIG_DIR}\/[^{}\"\.\)]*)\)"
  "${IN_MD_FILES}" INFIG)
list(TRANSFORM INFIG APPEND ".svg" OUTPUT_VARIABLE FIG_SVG)
list(TRANSFORM INFIG APPEND ".png" OUTPUT_VARIABLE FIG_PNG)
list(TRANSFORM INFIG APPEND ".pdf" OUTPUT_VARIABLE FIG_PDF)
list(TRANSFORM INFIG APPEND ".emf" OUTPUT_VARIABLE FIG_EMF)
SET(FIGFILES ${FIG_SVG} ${FIG_PNG} ${FIG_PDF})
list(TRANSFORM FIG_SVG
  REPLACE "${PROJECT_FIG_DIR}"  "${PROJECT_MEDIA_DIR}"
  OUTPUT_VARIABLE MEDIAFILES)
message(STATUS "     INFIG: ${INFIG}")
message(STATUS "MEDIAFILES: ${MEDIAFILES}")
################################################################################
# GLOBAL DEPS
SET(BIB_DEPS ${PROJECT_CSL} ${PROJECT_BIBFILES})
################################################################################

#INCLUDE(PDFTTpandoc)
IF(PROJECT_ENABLE_PDF)
  pandoc_build_tex(IN_BEFORE_FILES IN_BODY_FILES IN_AFTER_FILES)
ENDIF()

IF(is_mdh_enabled)
  pandoc_build_mdh( MDH_FILES)
  #message(STATUS "MDH_FILES: ${MDH_FILES}")
ENDIF()
IF(PROJECT_ENABLE_HTML)
  pandoc_build_html()
ENDIF()


