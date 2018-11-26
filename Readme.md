# pandoc-df-thesis-template — D. Folio [Pandoc] thesis template

This repository provides the D. Folio template for writing a thesis dissertation using [Pandoc], <http://pandoc.org>. Based on a “modified” markdown sources, this thesis template can deal with many outputs dialect basically supported by [Pandoc]:

- `pdf`: (**preferred**) output generated from (lua)[LaTeX];
- `html`: single (based solely on [Pandoc]) and multi (based on [Jekyll])  [HTML5] file, e.g. for web-publications;
- `epub`: [EPUB] v3 ebook;
- `docbook5`: XML/[DocBook] (v5) and HTML chunked files;
- `odt`: LibreOffice/OpenOffice OpenDocument [ODT];
- `docx`: Microsoft Word [DOCX];

> ## Important notice
> This template is not intended to be a standalone direct use template. Some basic behaviors that you may not want have been defined, and hardcoded in the `Makefile`. To *disable* some unwanted rules, it is necessary to know how to modify the `Makefile` properly.
> Feel free (under the CC-By-4.0 terms) to modify/adapt this template for your own purpose (I will appreciate some feedbacks).

## Quick Start

> Now as [wiki](https://github.com/dfolio/pandoc-df-thesis-template/wiki/Getting-Started)

1. Install or check if the following prerequires are available:
   - A [LaTeX] distribution (e.g. [TeXLive](http://www.tug.org/texlive/), [MacTeX](https://tug.org/mactex/)…)
     - Also recommended: [LuaLateX](http://www.luatex.org/), [BibLatex](https://github.com/plk/biblatex/) (with biber), [glossaries](http://www.ctan.org/pkg/glossaries/) packages
   - [Pandoc] for converting the Markdown to the output format of your choice.
     - Also recommended: [Pandoc-citeproc](https://github.com/jgm/pandoc-citeproc), [Pandoc-crossref](http://lierdakil.github.io/pandoc-crossref/), .
   - [PP](**mandatory**) : A generic Preprocessor (with [Pandoc] in mind).
     - [PP] allows to preprocess the markdown sources, enabling **macros** (or commands) in the “modified” markdown sources.
     - Installation:
       1. Download and extract [pp.tgz](https://cdsoft.fr/pp/pp.tgz).
       2. Run `make` (or `make install`) in the `pp/` folder.
2. Optionally look for the following packages:
   - [Jekyll]: used to generate `BUILD_HTML_FORMAT=htmlmulti` (e.g. for web-publishing)
   - [DocBook] toolchains: to build document from [DocBook] this templace use [DocBook XSL](http://www.sagehill.net/book-description.html) and thus requires a [XSLT](https://www.w3.org/TR/xslt/) (v1) processing tools, such as [xsltproc](http://xmlsoft.org/XSLT/xsltproc.html).
   - [SVGO](https://github.com/svg/svgo): SVG optimizer for images web-publications.
     - Basic installation: `npm install -g svgo`
   - [SASS]: to facilate the writting of [CSS](https://www.w3schools.com/css/) for web-publications.
     - Required if you want to compile CSS for `html`, `epub` and `docbook` target.
     - Basic Installation: `gem install sass`
   - [Bootstrap](https://getbootstrap.com): Build responsive, mobile-first projects on the web
     - Basic Installation: `npm install bootstrap`
3. Clone the [repository](https://github.com/dfolio/pandoc-df-thesis-template) on [Github](https://github.com/) in the proper place on your machine, e.g.:

   ```{sh}
   $ git clone https://github.com/dfolio/pandoc-df-thesis-template.git
   ```
4. Edit the `Makefile` (optional), and the `_data/variables.yml` (advised).

    >  **Note**: the basis metadata (title, authors,...) are defined in `_data/variables.yml`!

5. Once you have written some elements in the sources directory:  `_md/`, with your preferred markdown editor (e.g. [Atom](https://atom.io) (recommended), [Sublime](https://www.sublimetext.com/)…), from the root repository just try running:

   ```{sh}
   $ make <target>
   ```

   where `<target>` is one of the above output dialect (i.e. `pdf`, `html`, `epub`…)

   ```{sh}
   $ make help
   ```
   
   provides some _help_ on the other targets. 

Further informations on the directories organization are given in the [wiki](https://github.com/dfolio/pandoc-df-thesis-template/wiki) [How To?](https://github.com/dfolio/pandoc-df-thesis-template/wiki/How-To%3F) page.



[Pandoc]: http://pandoc.org
[LaTeX]: http://www.latex-project.org/
[HTML5]: http://www.w3.org/TR/html5/
[EPUB]: http://idpf.org/epub
[DocBook]: http://docbook.org/
[odt]: http://en.wikipedia.org/wiki/OpenDocument
[docx]: https://en.wikipedia.org/wiki/Office_Open_XML
[pp]: https://cdsoft.fr/pp/
[Jekyll]: https://jekyllrb.com/
[SASS]: https://github.com/sass/ruby-sass

