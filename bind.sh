#!/bin/bash

format="$1"
book="$2"

jekyll() {
# Build your books
bundle exec jekyll build
}

rename() {
# Rename files from .html to .md so Pandoc can parse them correctly
for f in _site/*/*.html; do
  mv -- "$f" "${f%.html}.md"
done
}

epub() {
jekyll
rename
# Create Default epub for every book in _site
# "${i%%.*}" gets the filename but ignores the extension
if [ "$book" == "all" ]; then
    for i in $(ls _site/*/ | grep epub); do
        mkdir -p Books/"${i%%-epub.md}"
        pandoc --toc-depth=1 --template=Pandoc/templates/custom-epub.html --epub-stylesheet=Pandoc/css/style.css --smart -o Books/"${i%%-epub.md}"/"${i%%-epub.md}".epub _site/*/$i
    done
else
    mkdir -p Books/"$book"
    pandoc --toc-depth=1 --template=Pandoc/templates/custom-epub.html --epub-stylesheet=Pandoc/css/style.css --smart -o Books/"$book"/"$book".epub _site/*/"$book"-epub.md
fi
}

smashwords() {
jekyll
rename
# Create Smashwords epub
if [ "$book" == "all" ]; then
    for i in $(ls _site/*/ | grep Smashwords); do
        mkdir -p Books/"${i%-Smashwords.md}"
        pandoc --toc-depth=1 --template=Pandoc/templates/smashwords-epub.html --epub-stylesheet=Pandoc/css/style.css --smart -o Books/"${i%-Smashwords.md}"/"${i%%.*}".epub _site/*/$i
    done
else
    mkdir -p Books/"$book"
    pandoc --toc-depth=1 --template=Pandoc/templates/smashwords-epub.html --epub-stylesheet=Pandoc/css/style.css --smart -o Books/"$book"/"$book"-Smashwords.epub _site/*/"$book"-Smashwords.md
fi
}

amazon() {
jekyll
rename
# Create mobi for every book in _site
if [ "$book" == "all" ]; then
    for i in $(ls _site/*/ | grep Amazon); do
        mkdir -p Books/"${i%-Amazon.md}"
        pandoc --toc-depth=1 --template=Pandoc/templates/amazon-epub.html --epub-stylesheet=Pandoc/css/style.css --smart -o Books/"${i%-Amazon.md}"/"${i%%.*}".epub _site/*/$i
    
        kindlegen -c2 Books/"${i%-Amazon.md}"/"${i%%.*}".epub
        rm Books/"${i%-Amazon.md}"/"${i%%.*}".epub
    done
else
    mkdir -p Books/"$book"
    pandoc --toc-depth=1 --template=Pandoc/templates/amazon-epub.html --epub-stylesheet=Pandoc/css/style.css --smart -o Books/"$book"/"$book"-Amazon.epub _site/*/"$book"-Amazon.md
    
    kindlegen -c2 Books/"$book"/"$book"-Amazon.epub
    rm Books/"$book"/"$book"-Amazon.epub
fi
}

print() {
jekyll
rename

# Create a bio page so we can append it to the end of the main document
pandoc --latex-engine=xelatex -o Books/bio.tex Source/_includes/bio.md

# Create PDF for every book in _site
# "${i%%.*}" gets the filename but ignores the extension
if [ "$book" == "all" ]; then
    for i in $(ls _site/*/ | grep pdf ); do
        mkdir -p Books/"${i%%-pdf.md}"
        pandoc --template=Pandoc/templates/cs-5x8-pdf.latex --latex-engine=xelatex --latex-engine-opt=-output-driver="xdvipdfmx -V 3 -z 0" -f markdown+backtick_code_blocks -o Books/"${i%%-pdf.md}"/"${i%%-pdf.md}"-print.pdf  -A Books/bio.tex _site/*/$i
    done
else
    mkdir -p Books/"$book"
    pandoc --template=Pandoc/templates/cs-5x8-pdf.latex --latex-engine=xelatex --latex-engine-opt=-output-driver="xdvipdfmx -V 3 -z 0" -f markdown+backtick_code_blocks -o Books/"$book"/"$book"-print.pdf  -A Books/bio.tex _site/*/"$book"-pdf.md
fi
}

pdf() {
jekyll
rename
# Create PDF for every book in _site
# "${i%%.*}" gets the filename but ignores the extension
if [ "$book" == "all" ]; then
    for i in $(ls _site/*/ | grep pdf ); do
        mkdir -p Books/"${i%%-pdf.md}"
        pandoc --template=Pandoc/templates/pdf.latex --latex-engine=xelatex -f markdown+backtick_code_blocks -o Books/"${i%%-pdf.md}"/"${i%%-pdf.md}"-ebook.pdf _site/*/$i
    done
else
    mkdir -p Books/"$book"
    pandoc --template=Pandoc/templates/pdf.latex --latex-engine=xelatex -f markdown+backtick_code_blocks -o Books/"$book"/"$book"-ebook.pdf _site/*/"$book"-pdf.md
fi
}

all() {
jekyll
rename
epub
smashwords
amazon
print
pdf
}

$1 $2
