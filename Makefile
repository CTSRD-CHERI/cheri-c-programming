NAME=cheri-c-programming
BIB=cheri.bib
.PHONY: check-bibliography sort-bibliography

${NAME}.pdf: ${NAME}.tex cheri.bib
	latexmk -bibtex -pdf ${NAME}

clean:
	latexmk -C ${NAME}
	rm -f ${NAME}.{aux,log,out,pdf}

sort-bibliography: ${BIB}
	biber --tool $^ --sortcase=false --strip-comments --sortdebug --isbn13 --isbn-normalise --fixinits \
	    --output_indent=4 --output_fieldcase=lower --sortlocale=en_GB \
	    --configfile=bib-cleanup.conf --validate-config --output-file=$^.sorted
	cmp $^.sorted $^ || (echo "Bibliography changed" && cp -f $^.sorted $^)
	rm -f $^.sorted
check-bibliography:
	biber --input-format=bibtex --input-encoding=UTF-8 --tool --validate-datamodel ${BIB} | grep -v "Missing mandatory field 'editor'"
