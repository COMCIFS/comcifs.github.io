# Create html from Markdown
%.html: %.md
	pandoc -f markdown -t html -o $@ --self-contained --toc -c markdown4.css $< 
#
all: CIF2_FAQ.html looping_proposal.html
#
