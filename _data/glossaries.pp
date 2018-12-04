\ifdef{XML}
~~~~~~~~~~~~~~
<?xml version="1.0" encoding="utf-8" ?>
<?xml-model href="http://docbook.org/xml/5.0/rng/docbook.rng" schematypens="http://relaxng.org/ns/structure/1.0"?>
<?xml-model href="http://docbook.org/xml/5.0/rng/docbook.rng" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<glossary xml:id='sec-glossary' >
  <glossaryinfo>
    <title>Index of Terms and Notations</title>
  </glossaryinfo>
!ifndef(_PP_GLO_TMP)(!def(_PP_GLO_TMP)(!env(PP_MACROS_PATH)_pp-xml-glo.tmp))
!quiet
~~~~~~~
!lit(\_PP_GLO_TMP)(pp)
~~~~~
!raw(\comment){ XML GLOSSARIES/ACRONYMS }
~~~~~
~~~~~~~
~~~~~~~~~~~~~~
\ifdef{HTML}
~~~~~~~~~~~~~~
!ifndef(_PP_GLO_TMP)(!def(_PP_GLO_TMP)(!env(PP_MACROS_PATH)_pp-html-glo.tmp))
# Index of Terms and Notations {#sec:glossary .unnumbered epub:type=appendix}
!quiet
~~~~~~~
!lit(\_PP_GLO_TMP)(pp)
~~~~~
!raw(\comment){ HTML GLOSSARIES/ACRONYMS   }
~~~~~
~~~~~~~
~~~~~~~~~~~~~~
\define{AcroEntry}{Add an acronym entry}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
\ifdef{XML}
~~~~~~~~~~~~~~
!quiet
~~~~~~~
!lit(\_PP_GLO_TMP)(pp)
~~~~~
\raw(\def){\1}{Default acronym for \1}{<glossterm class='acronym' role='acronym'>\1</glossterm>}
\raw(\def){\1}{Default acronym for \1}{<glossterm class='acronym' role='acronym'>\1</glossterm>}
\raw(\def){\1long}{Long acronym of \1}{\2}
\raw(\def){\1full}{\2 (<glossterm class='acronym' role='acronym'>\1</glossterm>)}
~~~~~
~~~~~~~
    <glossentry xml:id='acro-\1'>
      <glossterm>\1</glossterm>
      <glossdef><para>\ifdef{3}{<foreignphrase xml:lang='\3'>\2</foreignphrase>}{\2}</para></glossdef>
    </glossentry>
~~~~~~~~~~~~~~
\ifdef{HTML}
~~~~~~~~~~~~~~
!quiet
~~~~~~~
!lit(\_PP_GLO_TMP)(pp)
~~~~~
\raw(\def){\1}{Default acronym for \1}{[<abbrev title='\2'>\1</abbrev>](#acro:\1)}
\raw(\def){\1short}{Short acronym for \1}{[<abbrev title='\2'>\1</abbrev>](#acro:\1)}
\raw(\def){\1long}{Long acronym of \1}{[\1]{.acroterm}}
\raw(\def){\1full}{[\2]{.acroterm} (<abbrev title='\2'>\1</abbrev>)}
~~~~~
~~~~~~~
[\1]{#acro:\1 .acronym-item}

:   \ifdef{3}{[\2]{\if{\3==fr}{lang='fr' .french}{lang='\3'}}}{\2}
\undef(foreign)
~~~~~~~~~~~~~~
\ifdef{LATEX}
~~~~~~~~~~~~~~
  \newacronym{\1}{\1}{\2}
  \newcommand{\\1}{\acronymfont{\gls{\1}}\xspace}
  \newcommand{\\1short}{\acrshort{\1}\xspace}
  \newcommand{\\1long}{\acrlong{\1}\xspace}
  \newcommand{\\1full}{\acrfull{\1}\xspace}
~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
\define{GlossEntry}{Add a glossary entry}
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
\ifdef{HTML}
~~~~~~~~~~~~~~
!quiet
~~~~~~~
!lit(\_PP_GLO_TMP)(pp)
~~~~~
\raw(\def){\1}{[\2](#glos:\1){.glossterm} }
~~~~~
~~~~~~~
[\2]{#glos:\1 .glossterm-item}

:   \3
~~~~~~~~~~~~~~
\ifdef{XML}
~~~~~~~~~~~~~~
!quiet
~~~~~~~
!lit(\_PP_GLO_TMP)(pp)
~~~~~
\raw(\def){\1}{<glossterm>\2</glossterm>}
~~~~~
~~~~~~~
<glossentry xml:id="glos-\1">
  <glossterm>\2</glossterm>
  <glossdef><para>\3</para></glossdef>
</glossentry>
~~~~~~~~~~~~~~
\ifdef{LATEX}
~~~~~~~~~~~~~~
\newglossaryentry{glos:\1}{type=glg, name=\2, description={\3}}
\newcommand{\\1}{\gls{glos:\1}\xspace}
~~~~~~~~~~~~~~
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!comment{ Entries definition goes below **************************************}
\ifdef{HTML}
~~~~~~~~~~~~~~
## Lists of Acronyms {#sec:glos-acronym}
~~~~~~~~~~~~~~
\ifdef{LATEX}
~~~~~~~~~~~~~~
\SetGlossariesPreamble{
\renewcommand*{\acronymname}{\translate{List of Acronyms}}
\renewcommand*{\glossaryname}{\translate{List of Terms}}
}
~~~~~~~~~~~~~~
\ifdef{XML}
~~~~~~~~~~~~~~
<glossdiv><title xml:id='sec-glos-acronym'>Lists of Acronyms</title>
~~~~~~~~~~~~~~
\AcroEntry{DNA}{deoxyribonucleic acid}

\ifdef{HTML}
~~~~~~~~~~~~~~
## List of Terms {#sec:glos-glg}
~~~~~~~~~~~~~~
\ifdef{LATEX}
~~~~~~~~~~~~~~
\renewcommand*{\glossaryname}{\translate{List of Terms}}
~~~~~~~~~~~~~~
\ifdef{XML}
~~~~~~~~~~~~~~
</glossdiv>
<glossdiv><title xml:id='sec-glos-glg'>List of Terms</title>
~~~~~~~~~~~~~~

\GlossEntry{cell}{cell}
~~~~~~~~~~~~~~
The cell is the basic structural, functional, and biological unit of all known living organisms.
A cell is the smallest unit of life. Cells are often called the "building blocks of life". 
~~~~~~~~~~~~~~
!flushlit
\ifdef{XML}{</glossdiv></glossary>}
\ifndef{LATEX}{\import{\_PP_GLO_TMP}}

