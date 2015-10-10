#vim-live-latex

Automatic compile your latex file when your save latex.

Try to improve live latex from
- [vim-latex-live-preview](https://github.com/xuhdev/vim-latex-live-preview)  - dont' have any feedback
- [dispatch.vim](https://github.com/tpope/vim-dispatch) - not support latex error in QuickFix

## Screenshot:
![screenshot](/doc/ss.png)

## Usage:
1. Open Vim inside Tmux
2. Edit your latex file
3. Save your latex
4. Our plugin will automatic complie latex file and send feed back to
   your vim editor
5. Using Pdf viewer that have features auto-reload to look fresh latex
   output - [vim-latex-live-preview #Known Working PDF Viewers](https://github.com/xuhdev/vim-latex-live-preview/wiki/Known-Working-PDF-Viewers)

## Requirement:
- [Tmux](https://tmux.github.io)

## Custom Latex Compiler

Default latex compiler is `pdflatex`

```sh
# .vimrc
let g:live_latex_compiler = "xelatex"
```
## Support Multi-file LaTeX projects
- Need [Vimrc Custom](https://github.com/ibotdotout/vimrc-custom)

File structure
```sh
$tree
├── abstract.tex
├── acknowledgement.tex
│   └── appendix1.tex
│   └── appendix2.tex
│   └── chapter1.tex
│   └── chapter2.tex
│   └── chapter3.tex
│   └── chapter4.tex
│   └── chapter5.tex
├── thesis.tex
└── vitae.tex
```

`thesis.tex` is master latex file

```sh
# .vimrc.custom
# always need $PWD to using fullpath
autocmd BufWritePost *.tex call LiveLatexBuild($PWD."/thesis.tex")
```
