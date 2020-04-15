NAME=cheri-c-programming

${NAME}.pdf: ${NAME}.tex cheri.bib
	latexmk -bibtex -pdf ${NAME}

clean:
	rm -f ${NAME}.{aux,log,out,pdf}
