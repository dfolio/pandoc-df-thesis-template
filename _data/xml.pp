!comment( *** XML pp-macros set ********************************************** )
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
xml.pp v0.1 (2018-10-04) | PP v2.6
A set of macros for pandoc docbook5 (XML) output
--------------------------------------------------------------------------------
(c) 2017, David FOLIO CC-By-4.0 License.
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
!macrochars(\!)
\define{XML}
\define{xspace}{ }
!comment( *** references pp-macros set *************************************** )
\define{cite}{Latex cite}{ [@\1]}
\define{ref}{Latex ref}{[@\1]}
\define{cref}{[@\1]}
\define{label}{Latex label}{{#\1}}
!comment( *** bibliography pp-macros set ************************************* )
\define{doi}{[doi:\1](http://doi.org/\1){.doi}}

!comment( *** block pp-macros set ******************************************** )
\define{SkipAndBreak}{vertical skip with pagebreak}{<div class="SkipAndBreak" data-skip="\1"></div>}
\define{footnoterule}{<hr class="footnoterule">}

!comment( *** inline pp-macros set ******************************************* )
\define{emph}{Inline emphasis}{<emphasis class="em emphasis">\1</emphasis>}
\define{enquote}{Inline quote}{<quote class="enquote quote">\emph{\1}</quote>}
\define{uline}{Inline underline}{<emphasis role="underline">\1</emphasis>}
\define{Latin}{Inline latin phrase}{<foreignphrase xml:lang='la' class='latin'>\1</foreignphrase>}
\define{French}{Inline french phrase}{<foreignphrase xml:lang='fr' class='french'>\1</foreignphrase>}
\define{German}{Inline german phrase}{<foreignphrase xml:lang="de" class="german">\1</foreignphrase>}

\define{AbbrEn}{<abbrev xml:lang="en" >\2</abbrev>}
\define{AbbrFr}{<abbrev xml:lang="fr" class="french">\2</abbrev>}
!comment( *** unit pp-macros set ******************************************** )
\define{num}{Latex siunitx}{<mathphrase class="number">\1</mathphrase> }
\define{si}{Latex siunitx}{<mathphrase class="unit">\1</mathphrase>}
\define{SI}{Latex siunitx}{<mathphrase class="number">\1</mathphrase> \si{\2}}
\define{year}{year}
\define{years}{years}
\define{hour}{h}
\define{micro}{µ}
\define{metre}{m}


