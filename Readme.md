# D. Folio [Pandoc] thesis template

This repository provides the D. Folio template for writing a thesis dissertation
using [Pandoc], <http://pandoc.org>. Based on a “modified” markdown sources,
this thesis template can deal with many outputs dialect basically supported by
[Pandoc]:

- `pdf`: (**preferred**) output generated from (lua)[LaTeX];
- `html`: single [HTML5] file for web-publications;
- `epub`: [EPUB] v3 ebook;
- `docbook5`: XML [DocBook] and HTML chunked files;
- `odt`: LibreOffice/OpenOffice OpenDocument [ODT];
- `docx`: Microsoft Word [DOCX];

> ## Important notice
> This template is not intended to be a standalone direct use template. Some
> basic behaviors that you may not want have been defined, and hardcoded in
> the `Makefile`. To *disable* some unwanted rules, it is necessary to know how
> to modify the `Makefile` properly.
> Feel free (under the CC-By-4.0 terms) to modify/adapt this template for your
> own purpose (I will appreciate some feedbacks).

## Quick Start

1. Install or check if the following prerequires are available:
   - A [LaTeX] distribution (e.g. [TeXLive](http://www.tug.org/texlive/), [MacTeX](https://tug.org/mactex/)...)
     - Also recommended: [LuaLateX](http://www.luatex.org/), [BibLatex](https://github.com/plk/biblatex/) (with biber), [glossaries](http://www.ctan.org/pkg/glossaries/) packages
   - [Pandoc] for converting the Markdown to the output format of your choice.
     - Also recommended: [Pandoc-citeproc](https://github.com/jgm/pandoc-citeproc), [Pandoc-crossref](http://lierdakil.github.io/pandoc-crossref/), .
   - [PP](**mandatory**) : A generic Preprocessor (with [Pandoc] in mind).
     - [PP] allows to preprocess the markdown sources, enabling **macros** (or commands) in the “modified” markdown sources.
     - Installation:
       1. Download and extract [pp.tgz](https://cdsoft.fr/pp/pp.tgz).
       2. Run `make` (or `make install`) in the `pp/` folder.
2. Optionally look for the following packages:
   - [docbook] toolchains: to build document from [docbook] this templace use [DocBook XSL](http://www.sagehill.net/book-description.html) and thus requires a [XSLT](https://www.w3.org/TR/xslt/) (v1) processing tools, such as [xsltproc](http://xmlsoft.org/XSLT/xsltproc.html).
   - [SVGO](https://github.com/svg/svgo): SVG optimizer for images web-publications.
     - Basic installation: `npm install -g svgo`
   - [SASS](https://github.com/sass/ruby-sass): to facilate the writting of [CSS](https://www.w3schools.com/css/) for web-publications.
     - Required if you want to compile CSS for `html`, `epub` and `docbook` target.
     - Basic Installation: `gem install sass`
   - [Bootstrap](https://getbootstrap.com): Build responsive, mobile-first projects on the web
     - Basic Installation: `npm install bootstrap`
3. Clone the [repository](https://github.com/dfolio/pandoc-df-thesis-template) on [Github](https://github.com/) in the proper place on your machine, e.g.:

   ```{sh}
   $ git clone https://github.com/dfolio/pandoc-df-thesis-template.git
   ```

4. Once you have written some elements in the “modified” markdown sources within the `_md/` folder with your preferred markdown editor (e.g. [Atom](https://atom.io), [Sublime](https://www.sublimetext.com/)...), from the root repository just try running:

   ```{sh}
   $ make <target>
   ```

   where `<target>` is one of the above output dialect (i.e. `pdf`, `html`, `epub`…)

## How to deal with the template?

The template is organized as follows:

- `README.md`: these instructions;
- `License`: terms of reuse (CC-By-4.0 license);
- `Makefile`: contains instructions for building the thesis output based on [Pandoc] framework\
   You may need to modify this `Makefile` to fit your needs;
- `_data/`: auxiliary information on/for the thesis;
- `_layouts/`: where is stored the modified [Pandoc] template;
- `_md/`: the (modified) markdown sources of the dissertation;
- `_sass/`: these are [SASS](https://github.com/sass/ruby-sass) partials that can be imported into your `.scss` file swhich will then be processed into [CSS](https://www.w3schools.com/css/) styles that define the styles to be used for `html`, `epub` and `docbook5`.
- `_tex/`: the directory to hold the (lua)[LaTeX] intermediate output;
- `assets/`: the materials of the thesis (e.g. figures, bibliographies) or things planed to be published with the thesis;

Once a `make <target>` is performed, the following folders should appear:

- `_docbook/`: for the [DocBook](v5) intermediate files and the chunked `html` files;
- `_html/`: for the single [HTML5] intermediate files and the single [HTML5] file for web-publications;

### `_md/` {#dir-md}

The (modified) markdown sources of your dissertation should be placed in the
`_md/` directory. The following rules are considered:

- `0X_filename.md`: with `X` a digit, considered as contents to be placed before the body, such as “Acknowledgment”, “Preface”...;
- `[1-8]X_filename.md`: the main body contents, classically split in parts, chapters and/or sections;
- `9X_filename.md`: with `X` a digit, considered as contents to be placed after the body, e.g. “References”, “Glossaries”...;

If you have a very _big_ dissertation, you may have more than one `X` digit, but it is important to be consistent for all the filenames' definition.

### `_data/` {#dir-data}

In the `_data/` directory are placed auxiliary data for your documents:

- `_data/metadata.yml`: metadata for [Pandoc] and its filter (e.g. pandoc-citeproc and pandoc-crossref),
-  `_data/variables.yml`:and variable definition used by our [Pandoc] templates;
- `_data/macros.pp`: the main [PP]-macros that imports all other macros' definition files w.r.t. the dialect target:
    - `_data/latex.pp`: macros for [LaTeX] and then for the `pdf` target;
    - `_data/html.pp`: macros for [HTML];
    - `_data/docbook.pp`: macros for [DocBook];
    - `_data/glossaries.pp`: where terms, glossaries, acronyms... are defined.


### `_tex/` {#dir-tex}

If you want to handle the [LaTeX] source and its compilation process, the intermediate files, and the final [LaTeX] file are build there.
Let's remember that the final PDF file is build from (Lua)[LaTeX].

### `assets/` {#dir-assets}

The role of the `assets/` folder is twofold:

1. To be the place where _publishable_ materials can be stored, such as
   - `assets/bib/`: for the BibTeX bibliography files;
   - `assets/fonts/`: for the font faces;
   - `assets/media/`: for the multimedia materials (i.e. images, video...);
2. To be the place where files generated for web-publications are stored, such as:
   - `assets/css/`: for the (generated) [CSS](https://www.w3schools.com/css/) styles;
   - `assets/fig/`: for the generated/optimized figures;

Obviously, some elements could be placed elsewhere (e.g. in `_data/` folder), but the `Makefile` should be modified accordingly.

[pandoc]: http://pandoc.org
[latex]: http://www.latex-project.org/
[html5]: http://www.w3.org/TR/html5/
[epub]: http://idpf.org/epub
[docbook]: http://docbook.org/
[odt]: http://en.wikipedia.org/wiki/OpenDocument
[docx]: https://en.wikipedia.org/wiki/Office_Open_XML
[pp]: https://cdsoft.fr/pp/
