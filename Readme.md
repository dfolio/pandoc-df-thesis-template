# pandoc-df-thesis-template — D. Folio [Pandoc] thesis template

[![Travis Build Status](https://img.shields.io/travis/com/dfolio/pandoc-df-thesis-template.svg)][travis-ci]
[![License](https://img.shields.io/github/license/dfolio/pandoc-df-thesis-template.svg)][license]
[![Version](https://img.shields.io/github/tag/dfolio/pandoc-df-thesis-template.svg)][this-repo]
 [![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat)][this-issues]

This repository provides a **full featured** template for writing a thesis dissertation using [Pandoc], <http://pandoc.org>. Based on an “[extended Markdown](https://dfolio.github.io/docs/pandoc-df-thesis-template/df-markdown/)” sources, this template can deal with many outputs dialect basically supported by [Pandoc]

- `pdf`: (**preferred**) output generated from (pdf/lua)[LaTeX];
- `html`: single (based solely on [Pandoc]) and multi (based on [Jekyll])  [HTML 5][HTML] file, e.g. for web-publications;
- `epub`: [EPUB  v3][EPUB] ebook;
- `docbook5`: XML/[DocBook (v5)][DocBook] and [HTML] chunked files  (currently with **limited support**);
- `odt`:  [LibreOffice/OpenOffice OpenDocument][odt];
- `docx`: [Microsoft Word][docx]; etc.

 The proposed workflow allows to:
- improve the basic [Markdown markup][Markdown]  to address the add of macros/command/functions with a particular attention to support acronyms/glossaries (managed with [pp][pp])
- manage the figures/images with the proper format for the various output target,
- discover/manage the bibliography files,
- try to build/generate only necessaries files thanks to the dependencies management from the `make` build process, etc.


## Quick Start

> **Note:** Now as a [wiki](https://github.com/dfolio/pandoc-df-thesis-template/wiki/Getting-Started);
> and [documentation][doc] have started with a [Github-page][doc].

1. Install or check if the following prerequires are available: 
   - [Pandoc] (**mandatory**) &mdash; for converting the [Markdown] to the output format of your choice.
     - Also recommended: [Pandoc-citeproc] , [Pandoc-crossref]
   - [PP][pp] (**mandatory**) &mdash; A generic Preprocessor (with [Pandoc] in mind). [PP][pp] allows to preprocess the  “[extended Markdown](https://dfolio.github.io/docs/pandoc-df-thesis-template/df-markdown/)”  sources, enabling **macros** (or commands).
   - A `make` build system: all the template build workflow relies on the use of a `Makefile`. Thus, you **should** have a suitable `make` software.
   - A [LaTeX] distribution (e.g. [TeXLive](http://www.tug.org/texlive/), [MacTeX](https://tug.org/mactex/)…)
     - Also recommended: [LuaLateX](http://www.luatex.org/), [BibLatex](https://github.com/plk/biblatex/) (with biber), [glossaries](http://www.ctan.org/pkg/glossaries/) packages...

2. Recommanded packages:
    - [ImageMagick] : for image conversion between the different target.
    - [Inkscape] : to convert SVG images to other image format

      > **SVG is the recommanded** input format for images/pictures of the
      > dissertation contents. 
      > It will be then converted/optimized with respect to the considered output
      > target.

    - [NPM] : for complementary packages (eg. [Bootstrap], [JQuery], [MathJax], [SVGO](https://github.com/svg/svgo), etc…) mainly to deal with the [HTML] target.
    - [SASS][SASS]  to facilate the writting of [CSS](https://www.w3schools.com/css/) for web-publications. **Required** if you want to compile [CSS](https://www.w3schools.com/css/)  for `html`, `epub` and `docbook` targets.


3. Optionally look for the following optional packages:
   - [DocBook][DocBook] toolchains: to build document from [DocBook][DocBook] this templace use [DocBook XSL](http://www.sagehill.net/book-description.html) and thus requires a [XSLT](https://www.w3.org/TR/xslt/) (v1) processing tools, such as [xsltproc](http://xmlsoft.org/XSLT/xsltproc.html).
   - [Jekyll]  used to generate `BUILD_HTML_FORMAT=htmlmulti` (e.g. for web-publishing)
     - Thus also recommanded [Gem](https://rubygems.org/)  / [Bundle](https://bundler.io) to deal with [Jekyll] plugins
   - [SVGO](https://github.com/svg/svgo): SVG optimizer for images web-publications.
   - [Bootstrap](https://getbootstrap.com): Build responsive, mobile-first projects on the web

4. Clone the [repository](https://github.com/dfolio/pandoc-df-thesis-template) on [Github](https://github.com/) in the proper place on your machine, e.g.:

   ```{console}
   $ git clone https://github.com/dfolio/pandoc-df-thesis-template.git
   ```
5. Edit the `Makefile` (optional), and the `_data/variables.yml` (advised).

    > **Note**: the basis metadata (title, authors,...) are defined in `_data/variables.yml`!

6. Once you have written some elements in the sources directory:  `_md/`, with your preferred [Markdown] editor (e.g. [Atom](https://atom.io), [Sublime](https://www.sublimetext.com/)…), from the root repository of your dissertation just try running:

   ```{console}
   $ make <target>
   ```

   where `<target>` is one of the above output dialect (i.e. `pdf`, `html`, `epub`…).
   Further information about the relevant targets can be shown with the `help` rule:

   ```{console}
   $ make help
   ```

   provides some _help_ on the other targets. 

Further informations on the directories organization are given in the [wiki](https://github.com/dfolio/pandoc-df-thesis-template/wiki) [How To?](https://github.com/dfolio/pandoc-df-thesis-template/wiki/How-To%3F) page.
The template [documentations][doc] have started with a [Github pages][doc].

## Contributes 

Feel free (under the [CC-By-4.0 terms](https://github.com/dfolio/pandoc-df-thesis-template/blob/master/LICENSE)) to modify/adapt this template for your own purpose (I will appreciate some [feedback][share] :+1:).  To this aim you can:

1. [Fork it](http://github.com/dfolio/pandoc-df-thesis-template/fork) : go to the [pandoc-df-thesis repository](http://github.com/dfolio/pandoc-df-thesis-template)   and hit the fork button in the upper right corner.
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new [Pull Request](https://github.com/dfolio/pandoc-df-thesis-template/pulls) with your contributions
6. Please give [me your feedbacks][share] or [share the template][share] on your social-networks (show the [Github pages][doc] [documentations][share] for this)

For any troubleshooting read, and (eventually) [create an issue][this-issues] on [pandoc-df-thesis-template][this-repo] [GitHub] repository.


[DocBook]: http://docbook.org/ "DocBook is a semantic markup language for technical documentation."
[docx]: https://en.wikipedia.org/wiki/Office_Open_XML "Docx is a zipped, XML-based file format developed by Microsoft for representing word processing"
[EPUB]: http://idpf.org/epub "EPUB is an e-book file format. EPUB files can be read using complying software on devices such as smartphones, tablets, computers, or e-readers."
[GitHub]: https://github.com "GitHub Inc. is a web-based hosting service for version control using Git."
[HTML]: http://www.w3.org/TR/html5/ "HTML5 is a markup language used for structuring and presenting content on the World Wide Web"
[ImageMagick]: https://www.imagemagick.org/ "Use ImageMagick to convert images"
[Inkscape]: https://inkscape.org/ "Draw freely: Inkscape is professional quality vector graphics software that uses the W3C open standard SVG (Scalable Vector Graphics) as its native format, and is free and open-source software."
[Jekyll]: https://jekyllrb.com/ "Jekyll is a simple, blog-aware, static site generator for personal, project, or organization sites. Jekyll is developed in Ruby by Tom Preston-Werner."
[JQuery]: https://jquery.com/ "jQuery: The Write Less, Do More, JavaScript Library"
[LaTeX]: http://www.latex-project.org/ "TeX/LaTeX is a document preparation system."
[Liquid]: https://shopify.github.io/liquid/ " Liquid is a templating language to process templates."
[Markdown]: https://daringfireball.net/projects/markdown/ "Markdown is a lightweight markup language with plain text formatting syntax. It is developed by John Gruber."
[Make]: https://en.wikipedia.org/wiki/Make_(software) "Make is a build automation tool that automatically builds from source code by reading files called Makefiles which specify how to derive the targeted build. "
[MathJax]: http://www.mathjax.org/ "Beautiful math in all browsers"
[NPM]: https://www.npmjs.com/ "npm is the package manager for JavaScript and the world's largest software registry. "
[odt]: http://en.wikipedia.org/wiki/OpenDocument "The Open Document Format for Office Applications (ODF), also known as OpenDocument, is a ZIP-compressed XML-based file format for word processing documents. "
[Pandoc]: http://pandoc.org "Pandoc is a free and open-source software document converter, widely used as a writing tool"
[pandoc-citeproc]: https://github.com/jgm/pandoc-citeproc "Library and executable for using citeproc with pandoc"
[pandoc-crossref]: https://github.com/lierdakil/pandoc-crossref "Pandoc filter for cross-references "
[pp]: https://cdsoft.fr/pp/ "PP is a generic Preprocessor (with Pandoc in mind)"
[SASS]: https://github.com/sass/ruby-sass "Sass (Syntactically awesome style sheets) is a preprocessor scripting language that is interpreted or compiled into Cascading Style Sheets (CSS)."
[travis-ci]: https://travis-ci.com/dfolio/pandoc-df-thesis-template "Travis status"
[this-repo]: http://github.com/dfolio/pandoc-df-thesis-template "pandoc-df-thesis-template GitHub repo"
[this-issues]: http://github.com/dfolio/pandoc-df-thesis-template/issues "pandoc-df-thesis-template issues"
[doc]: http://dfolio.github.io/docs/pandoc-df-thesis-template/ "pandoc-df-thesis-template documentations"
[share]: http://dfolio.github.io/docs/pandoc-df-thesis-template/#leave-comment "share/react to the pandoc-df-thesis template"
[license]: https://github.com/dfolio/pandoc-df-thesis-template/blob/master/LICENSE "pandoc-df-thesis-template license (CC-BY-4.0)"

