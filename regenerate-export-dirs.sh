#!/bin/bash

dirs=(
    ./breeze-expanded
    ./breeze-expanded-dark
)

function create_export_dirs () {
    local EXPORT_DIR="$1"
    if [ -d "$EXPORT_DIR" ]; then
        echo Directory still exists - Please remove it first
        return
    fi

    mkdir -p "$EXPORT_DIR/mimetypes"
    mkdir "$EXPORT_DIR/mimetypes/16"
    ln -s 16 "$EXPORT_DIR/mimetypes/16@2x"
    ln -s 16 "$EXPORT_DIR/mimetypes/16@3x"
    mkdir "$EXPORT_DIR/mimetypes/22"
    ln -s 22 "$EXPORT_DIR/mimetypes/22@2x"
    ln -s 22 "$EXPORT_DIR/mimetypes/22@3x"
    mkdir "$EXPORT_DIR/mimetypes/32"
    mkdir "$EXPORT_DIR/mimetypes/64"
}

for d in "${dirs[@]}"; do
    create_export_dirs "$d"
done
