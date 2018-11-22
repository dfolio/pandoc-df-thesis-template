# Special note for windows



## Installation guide for Windows



> ### Important notice
>
> Some actions listed below should require some administration grant on you PC/Windows. If you do not have such grant contact your administrator.



Install or check if the following prerequires are available:

- A [LaTeX] distribution (e.g. [MikeTeX](https://miktex.org), see https://miktex.org/howto/install-miktex)

  - Also recommended: [LuaLateX](http://www.luatex.org/), [BibLatex](https://github.com/plk/biblatex/) (with biber), [glossaries](http://www.ctan.org/pkg/glossaries/) packages

- [Pandoc] for converting the Markdown to the output format of your choice (see https://pandoc.org/installing.html).

  - Also recommended: [Pandoc-citeproc](https://github.com/jgm/pandoc-citeproc), [Pandoc-crossref](http://lierdakil.github.io/pandoc-crossref/), .

  - To do so it will be convenient to install [Haskell Stack](https://docs.haskellstack.org/), and perform (e.g. from command line)

    ```sh
    stack.exe install pandoc-citeproc
    stack.exe install pandoc-crossref
    ```

- [PP](**mandatory**) : A generic Preprocessor (with [Pandoc] in mind).

  - [PP] allows to preprocess the markdown sources, enabling **macros** (or commands) in the “modified” markdown sources.
  - Installation:
    1. Download and extract https://cdsoft.fr/pp/pp-win.7z (Windows precompiled binaries)
    2. Run `make` (or `make install`) in the `pp/` folder