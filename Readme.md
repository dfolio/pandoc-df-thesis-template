# pandoc-df-thesis-template — D. Folio [Pandoc] thesis template

[![Travis](https://img.shields.io/travis/com/dfolio/pandoc-df-thesis-template.svg)][travis-ci]
[![Size](https://img.shields.io/github/repo-size/dfolio/pandoc-df-thesis-template.svg)][github-io]
[![Version](https://img.shields.io/github/tag/dfolio/pandoc-df-thesis-template.svg)][github-io]
[![License](https://img.shields.io/github/license/dfolio/pandoc-df-thesis-template.svg)](https://raw.githubusercontent.com/dfolio/pandoc-df-thesis-template/master/LICENSE)


This repository provides a **full featured** template for writing a thesis dissertation using [Pandoc], <http://pandoc.org>. Based on a “modified” markdown sources, this template can deal with many outputs dialect basically supported by [Pandoc]

- `pdf`: (**preferred**) output generated from (pdf/lua)[LaTeX];
- `html`: single (based solely on [Pandoc]) and multi (based on [Jekyll])  [HTML]&nbsp;5 file, e.g. for web-publications;
- `epub`: [EPUB] v3 ebook;
- `docbook5`: XML/[DocBook][DocBook] (v5) and HTML chunked files  (currently with **limited support**);
- `odt`:  [LibreOffice/OpenOffice OpenDocument][odt];
- `docx`: [Microsoft Word][docx];


## Quick Start

> **Note:** Now as a [wiki](https://github.com/dfolio/pandoc-df-thesis-template/wiki/Getting-Started);
> and [documentation][pandoc-df-thesis-template] have started with a [Github-page][pandoc-df-thesis-template].

1. Install or check if the following prerequires are available: [glossaries](http://www.ctan.org/pkg/glossaries/) packages
   - [Pandoc] (**mandatory**) &mdash; for converting the [Markdown] to the output format of your choice.
     - Also recommended: [Pandoc-citeproc] , [Pandoc-crossref]
   - [PP][PP] (**mandatory**) &mdash; A generic Preprocessor (with [Pandoc] in mind).
     - [PP][PP] allows to preprocess the markdown sources, enabling **macros** (or commands) in the “modified” markdown sources.
     - Installation:
       1. Download and extract [pp.tgz](https://cdsoft.fr/pp/pp.tgz).
       2. Run `make` (or `make install`) in the `pp` folder.
      
   - A [LaTeX] distribution (e.g. [TeXLive](http://www.tug.org/texlive/), [MacTeX](https://tug.org/mactex/)…)
     - Also recommended: [LuaLateX](http://www.luatex.org/), [BibLatex](https://github.com/plk/biblatex/) (with biber),
     
2. Recommanded packages:
   - [Jekyll]  used to generate `BUILD_HTML_FORMAT=htmlmulti` (e.g. for web-publishing)
   - [Bootstrap](https://getbootstrap.com): Build responsive, mobile-first projects on the web
     - Basic Installation: `npm install bootstrap`
   - [SASS][SASS]  to facilate the writting of [CSS](https://www.w3schools.com/css/) for web-publications.
     - Required if you want to compile CSS for `html`, `epub` and `docbook` target.
     - Basic Installation: `gem install sass`
3. Optionally look for the following packages:
   - [DocBook][DocBook] toolchains: to build document from [DocBook][DocBook] this templace use [DocBook XSL](http://www.sagehill.net/book-description.html) and thus requires a [XSLT](https://www.w3.org/TR/xslt/) (v1) processing tools, such as [xsltproc](http://xmlsoft.org/XSLT/xsltproc.html).
   - [SVGO](https://github.com/svg/svgo): SVG optimizer for images web-publications.
     - Basic installation: `npm install -g svgo`
     
4. Clone the [repository](https://github.com/dfolio/pandoc-df-thesis-template) on [Github](https://github.com/) in the proper place on your machine, e.g.:

   ```{console}
   $ git clone https://github.com/dfolio/pandoc-df-thesis-template.git
   ```
4. Edit the `Makefile` (optional), and the `_data/variables.yml` (advised).

    > **Note**: the basis metadata (title, authors,...) are defined in `_data/variables.yml`!

5. Once you have written some elements in the sources directory:  `_md/`, with your preferred markdown editor (e.g. [Atom](https://atom.io) (recommended), [Sublime](https://www.sublimetext.com/)…), from the root repository just try running:

   ```{console}
   $ make <target>
   ```

   where `<target>` is one of the above output dialect (i.e. `pdf`, `html`, `epub`…)

   ```{console}
   $ make help
   ```
   
   provides some _help_ on the other targets. 

Further informations on the directories organization are given in the [wiki](https://github.com/dfolio/pandoc-df-thesis-template/wiki) [How To?](https://github.com/dfolio/pandoc-df-thesis-template/wiki/How-To%3F) page.
The template 
[documentations][pandoc-df-thesis-template] have started with a [Github][pandoc-df-thesis-template].

## Contributes

For any troubleshooting read, and (eventually) [create an issue](https://github.com/dfolio/pandoc-df-thesis-template/issues) on [pandoc-df-thesis-template](https://github.com/dfolio/pandoc-df-thesis-template/) [GitHub] repository.

Feel free (under the [CC-By-4.0 terms](https://github.com/dfolio/pandoc-df-thesis-template/blob/master/LICENSE)) to modify/adapt this template for your own purpose (I will appreciate some [feedbacks :+1:][github-io]).

[DocBook]: http://docbook.org/ "DocBook is a semantic markup language for technical documentation."
[docx]: https://en.wikipedia.org/wiki/Office_Open_XML "Docx is a zipped, XML-based file format developed by Microsoft for representing word processing"
[EPUB]: http://idpf.org/epub "EPUB is an e-book file format. EPUB files can be read using complying software on devices such as smartphones, tablets, computers, or e-readers."
[GitHub]: https://github.com "GitHub Inc. is a web-based hosting service for version control using Git."
[HTML]: http://www.w3.org/TR/html5/ "HTML5 is a markup language used for structuring and presenting content on the World Wide Web"
[Jekyll]: https://jekyllrb.com/ "Jekyll is a simple, blog-aware, static site generator for personal, project, or organization sites. Jekyll is developed in Ruby by Tom Preston-Werner."
[LaTeX]: http://www.latex-project.org/ "TeX/LaTeX is a document preparation system."
[Liquid]: https://shopify.github.io/liquid/ " Liquid is a templating language to process templates."
[Markdown]: https://daringfireball.net/projects/markdown/ "Markdown is a lightweight markup language with plain text formatting syntax. It is developed by John Gruber."
[Make]: https://en.wikipedia.org/wiki/Make_(software) "Make is a build automation tool that automatically builds from source code by reading files called Makefiles which specify how to derive the targeted build. "
[odt]: http://en.wikipedia.org/wiki/OpenDocument "The Open Document Format for Office Applications (ODF), also known as OpenDocument, is a ZIP-compressed XML-based file format for word processing documents. "
[Pandoc]: http://pandoc.org "Pandoc is a free and open-source software document converter, widely used as a writing tool"
[pandoc-citeproc]: https://github.com/jgm/pandoc-citeproc "Library and executable for using citeproc with pandoc"
[pandoc-crossref]: https://github.com/lierdakil/pandoc-crossref "Pandoc filter for cross-references "
[pp]: https://cdsoft.fr/pp/ "PP is a generic Preprocessor (with Pandoc in mind)"
[SASS]: https://github.com/sass/ruby-sass "Sass (Syntactically awesome style sheets) is a preprocessor scripting language that is interpreted or compiled into Cascading Style Sheets (CSS)."


[travis-ci]: https://travis-ci.com/dfolio/pandoc-df-thesis-template "Travis status"
[github-io]: http://github.com/dfolio/pandoc-df-thesis-template
[pandoc-df-thesis-template]: http://dfolio.github.io/docs/pandoc-df-thesis-template/ "pandoc-df-thesis-template documentations"

