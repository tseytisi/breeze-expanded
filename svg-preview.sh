#!/bin/bash
# Convenience script to start the Typst compiler watching the SVG file
# saves the PDF output to /tmp and opens Okular to preview the file

# "Don't forget to set-e-u-o pipefail because Bash will take every opportunity to delete your computer"
set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: svg-preview.sh <svg-file>"
    exit 0
fi

# Resolve and save the SVG file's path before setting the working directory
# so you can launch this script from anywhere and use the shell to complete paths
svg_fullpath="$(realpath "$1")"

# Set the directory to the project root, required by Typst
cd "$(dirname "$0")"

# Typst requires relative paths
svg_relpath="$(realpath --relative-to "$PWD" "$svg_fullpath")"

# Generate PDF name
declare outputfile
if [[ "$svg_relpath" == *.svg ]]; then
    outputfile="$(basename "$svg_relpath" .svg)-preview.pdf"
else
    outputfile="$(basename "$svg_relpath")-preview.pdf"
fi

if [ -z "$outputfile" ]; then
    return 1
fi

fulloutputfile="/tmp/$outputfile"

if ! typst compile svg-preview.typ "$fulloutputfile" --input file="$svg_relpath"; then
    # Okular refuses to try again if it fails to open the PDF once
    # So create an empty PDF for Okular to open in the meantime
    echo "" | typst compile - "$fulloutputfile"
    if [ `command -v kdialog` &>/dev/null 2>&1 ]; then
        kdialog --title "SVG Preview" --error "The document failed to compile"
    else
        notify-send -a "SVG Preview" -i "dialog-error" "The document failed to compile"
    fi
fi
okular "$fulloutputfile" &>/dev/null 2>&1 &
disown
typst watch svg-preview.typ "$fulloutputfile" --input file="$svg_relpath"
