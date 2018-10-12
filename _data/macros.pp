!comment(   pp-macros loader module   )
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"macros.pp v0.1 (2018-10-0.4) | PP v2.6
The main macro that imports all other macro definition files.
--------------------------------------------------------------------------------
(c) 2017, David FOLIO CC-By-4.0 License.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!macrochars(\!)
!ifdef(LATEX)(!import(latex.pp))
!ifdef(HTML)(!import(html.pp))
!ifdef(XML)(!import(xml.pp))

!ifndef(LATEX)(
!define(etal)(\Latin(et&nbsp;al.))
!define(ellip)(…)
!define(nameref)( [@\1])
)

!comment( *** constant pp-macros set ***************************************** )
\define{DavidFolio}{\BibAuthor{strong}{David}{FOLIO}}

\define{CVL}{\French{Centre Val de Loire}}
\define{PhD}{\Latin{PhD}}

\define{IndexTerms}{[index of terms and notations](#sec:glossary)}
\define{AcronymsList}{[list of acronyms](#sec:glossary)}
\define{TermsList}{[list of terms](#sec:glossary)}
