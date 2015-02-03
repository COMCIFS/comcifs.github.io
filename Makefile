# Create html from Markdown
all: CIF2_FAQ.md
	pandoc -f markdown -t html -o CIF2_FAQ.html --standalone -c markdown4.css CIF2_FAQ.md
