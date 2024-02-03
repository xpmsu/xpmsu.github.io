#!/bin/bash

md_directory="."

html_directory="./docs"
mkdir -p "$html_directory"
rm -f "$html_directory"/*.html

md_files=$(find -L "$md_directory" -type f -name "*.md")

echo "<p>hello this is a simple blog about research and programming</p>" >> "$html_directory/index.html"

echo "<b>index</b>" >> "$html_directory/index.html"
echo "<ul>" >> "$html_directory/index.html"

files=()
for md_file in $md_files; do
    filename=$(basename -- "$md_file")
    filename_no_ext="${filename%.*}"
    pandoc "$md_file" -B includes/header.html -o "$html_directory/$filename_no_ext.html"
    file_update=$(date -r "$md_file" "+%Y-%m-%d")
    files+=("$file_update $filename_no_ext")
done

IFS=$'\n' sorted=($(sort -r <<<"${files[*]}"))
unset IFS

for i in "${sorted[@]}"
do
    echo "<li><a href=\"${i:11}.html\">${i:11}</a> ${i:0:10}</li>" >> "$html_directory/index.html"
done

echo "</ul>" >> "$html_directory/index.html"
echo "<br><hr>" >> "$html_directory/index.html"
echo "last updated: $(date)" >> "$html_directory/index.html"
echo "Website built successfully! Check the 'build' directory."
