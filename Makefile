NAME=cheri-c-programming
BIB=cheri.bib
.PHONY: check-bibliography sort-bibliography all

all:
	latexmk -bibtex -pdf $(NAME) --jobname=$(NAME)-final -output-directory=build
	cp -f "build/$(NAME)-final.pdf" "$(NAME).pdf"
draft:
	latexmk -bibtex -pdf $(NAME) --jobname=$(NAME)-draft --output-directory=build-draft
	cp -f "build-draft/$(NAME)-draft.pdf" "$(NAME)-draft.pdf"

clean:
	latexmk -C $(NAME)
	rm -rf build build-draft
	rm -f $(NAME).{aux,log,out,pdf,bbl}

sort-bibliography: $(BIB)
	biber --tool $^ --sortcase=false --strip-comments --sortdebug --isbn13 --isbn-normalise --fixinits \
	    --output_indent=4 --output_fieldcase=lower --sortlocale=en_GB --nolog \
	    --configfile=bib-cleanup.conf --validate-config --output-file=$^.sorted
	cmp $^.sorted $^ || (echo "Bibliography changed" && cp -f $^.sorted $^)
	rm -f $^.sorted
check-bibliography:
	biber --input-format=bibtex --input-encoding=UTF-8 --tool --validate-datamodel $(BIB) | grep -v "Missing mandatory field 'editor'"
