NAME=cheri-c-programming

${NAME}.pdf: ${NAME}.tex
	latexmk -pdf ${NAME}

clean:
	rm -f ${NAME}.{aux,log,out,pdf}
