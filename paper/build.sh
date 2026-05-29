#!/bin/sh

rm -f paper.aux paper.bbl paper.blg paper.log paper.out paper.tex

# Insert appendix at the correct location
awk '
  /^# Appendix/ {
    print;
    system("cat appendix.md");
    next;
  }
  { print }
' paper-source.md > paper-source-with-appendix.md

# Generate LaTeX with crossref and bibliography
pandoc paper-source-with-appendix.md \
    --template=template.tex \
    --filter pandoc-crossref \
    --output=paper.tex \
    --natbib

pdflatex -interaction=nonstopmode paper.tex
bibtex paper
pdflatex -interaction=nonstopmode paper.tex
pdflatex -interaction=nonstopmode paper.tex

rm -f paper.aux paper.bbl paper.blg paper.log paper.out paper.tex paper-source-with-appendix.md
