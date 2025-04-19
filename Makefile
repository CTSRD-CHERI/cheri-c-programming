NAME=cheri-c-programming
BIB=latex/cheri.bib
.PHONY: all latex pdf clean

# Extract list of Markdown source files from mdbook TOC
MD_SRC_FILES=`pandoc src/SUMMARY.md --lua-filter=filters/md-source-list.lua -t plain`

all: latex pdf

latex: latex/sections.tex latex/abstract.tex

latex/abstract.tex: src/introduction/README.md
	pandoc src/introduction/README.md --lua-filter=filters/latex-abstract.lua -t latex -o latex/abstract.tex

latex/sections.tex: src/SUMMARY.md src/*/*.md
	pandoc $(MD_SRC_FILES) --lua-filter=filters/latex-custom-formats.lua --lua-filter=filters/latex-xref-fixup.lua -t latex -o latex/sections.tex

pdf: latex/$(NAME).tex latex/sections.tex latex/abstract.tex
	latexmk -pdf latex/$(NAME) --jobname=$(NAME)-final -output-directory=latex/build
	cp -f "latex/build/$(NAME)-final.pdf" "$(NAME).pdf"

techreport: latex/$(NAME).tex latex/sections.tex latex/abstract.tex
	latexmk -pdf latex/$(NAME) --jobname=$(NAME)-techreport -output-directory=latex/build-techreport
	cp -f "latex/build-techreport/$(NAME)-techreport.pdf" "$(NAME)-techreport.pdf"

clean:
	rm -rf latex/build latex/build-draft
