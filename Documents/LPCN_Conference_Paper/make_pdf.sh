latex $1
bibtex *.aux
latex $1
latex $1
dvips *.dvi
rm *.dvi
ps2pdf *.ps
rm *.ps

