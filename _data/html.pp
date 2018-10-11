!comment( *** HTML pp-macros set ********************************************** )
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
html.pp v0.1 (2018-10-08) | PP v2.6
A set of macros for pandoc HTML output
--------------------------------------------------------------------------------
(c) 2017, David FOLIO CC-By-4.0 License.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!macrochars(\!)
\define{HTML}
\define{xspace}{ }
!comment( *** references pp-macros set *************************************** )
\define{cite}{Latex cite}{ [@\1]}
\define{ref}{Latex ref}{[@\1]}
\define{cref}{Latex clever ref}{[@\1]}
\define{label}{Latex label}{{#\1}}

!comment( *** bibliography pp-macros set ************************************* )
\define{doi}{DOI link}{[doi:\1](http://doi.org/\1){.doi}}
!comment( *** block pp-macros set ******************************************** )
\define{SkipAndBreak}{vertical skip with pagebreak}{<div class="SkipAndBreak" data-skip="\1"></div>}
\define{footnoterule}{<hr class="footnoterule">}

!comment( *** inline pp-macros set ******************************************* )
\define{emph}{<span class="em">*\1*</span>}
\define{enquote}{<span class="enquote">&ldquo;\emph{\1}&rdquo;</span>}
\define{uline}{<span class="uline underline">\1</span>}
\define{Latin}{<span lang="la" class="latin">\1</span>}
\define{French}{<span lang="fr" class="french" custom-style="French">\1</span>}
\define{German}{<span lang="de" class="german">\1</span>}

\define{AbbrEn}{<abbr lang="en" title="\1">\2</abbr>}
\define{AbbrFr}{<abbr lang="fr" title="\1">\2</abbr>}

!comment( *** unit pp-macros set ******************************************** )
\define{num}{Latex siunitx}{<span class="number">\1</span>}
\define{si}{Latex siunitx}{<span class="unit">\1</span>}
\define{SI}{Latex siunitx}{<span class="number">\1</span><span class="unit">\2</span>}
\define{year}{year}
\define{years}{years}
\define{hour}{h}
\define{micro}{µ}
\define{metre}{m}
