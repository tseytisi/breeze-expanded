# Breeze Expanded
Extra icons for KDE's Breeze theme.

No icon theme can possibly have icons for every file type, but for some file types I do want to have pretty icons where Breeze does not provide them. This repository contains icons I created myself by hand. It includes a few icons for specific types, as well as some generic icons you can manually assign to types you want to identify more easily.

Currently, there are only mimetype icons.

Included icons, among others:
- A few inode types: `blockdevice`, `chardevice`, `fifo` (better known as a pipe) and `socket`.
- SystemD `.service` and `.timer` files
- Shell script, source code and plaintext icons in multiple colours
- Lock files
- and more...

## Installation
The easiest way to install the theme is to copy or symlink `breeze-expanded(-dark)` to `~/.local/share/icons/` (directory may not exist yet), and then select the theme from the KDE settings menu. The theme will automatically inherit from Breeze (Dark). You can add other Breeze expansion packs to the list to inherit from them first. Just add their directory name to the `Inherits` part of `index.theme`.

You don't need the `source` directory to use the icons. The source directory contains icon files that include all four sizes in a single file. They need to be exported before they can be used. The exporter is also self-made, and is not (yet) released on Github.

## Preview
Quickly see differences in filetypes in `/dev/`. Most files are char devices, the bottom row is block devices, and there is one socket.
![A grid of files previewing the icons for char and block devices](./readme-imgs/preview-device-files.png)

Differenciate different types of shell script (these do need to be manually assigned)
![Four files with differently coloured icons for Windows Batch, PowerShell, a regular shell script and VBScript](./readme-imgs/preview-scripts.png)

## Known issues
I recently tried my theme on Ubuntu 24.04LTS (with KDE frontend) with Plasma 5 and saw that it struggles with icons that use the 'currentColor' directive in SVG files... which is every icon I've made. If the icons look a lot more black than you'd expect, that's probably the reason. The fix is replacing every 'currentColor' with the colour code of the current colour, usually defined in the class.

The exporter has been updated to resolve currentColor values at build-time, so this issue should be solved. It has however not been tested yet.

## New icons
There's an ever-growing list of file types I want to create icons for. So I'll probably continue to update this repository... slowly. Though, if there's a specific file type you really want an icon for, you can always request it. No promises if and when I'll get to it though.

## Included tools
Alongside the icons source and export files, there is a small bit of tooling included too. These are not required to use or view the icons, but are used for development.

`regenerate-export-dirs.sh` is very self-explanatory. It creates the necessary directories and symbolic links.

### SVG previewer
I create SVGs by just... writing the code myself, with a text editor. SVGs, internally, are just grids with instructions like 'line from (0,1) to (4,4)' or 'circle with radius 2 at (5,3)'. For simple icons such as these, I think this is much easier than fighting Inkscape to make my icon symmetric and grid-aligned. (it's fighting only because I suck at Inkscape).

For this, I need a program to preview SVG files from disk and update them live when I change the file. I used to use Geeqie for this, but it recently got updated and now it sucks. Aside from that, I was working with SVGs in Typst recently, and noticed that it's quicker to compile a 10 page super complicated PDF with Typst and wait for Okular to update the preview, than Geeqie can reload a single SVG, so I have "created" my own SVG previewer using Typst and Okular.

This comes with the added benefit that Typst allows you to construct images from raw bytes, so I can pre-process SVGs. This allowed me to add include statements to the SVGs, since `<use href="<file>.svg#symbol-id" />` is very poorly supported.

The file `common.xml` contains common components used for creating new icons, such as a grid and the borders in which the icons should fit. Only the Typst previewer can properly load in those components, but they are only used during development.

Typst is _absolutely_ not meant to open arbitrary files, and is a little picky about what its project tree looks like. It also doesn't have shell completion for filepaths in its `--input` parameters (because you generally don't put filepaths in there). To make it easier to preview files, I made `svg-preview.sh`.

From within the `mimetypes` directory, you can run `../../svg-preview.sh application-x-jsp.svg`, which will launch the Typst compiler in the current terminal, and open Okular to auto-reload the previewed SVG. From the root, `./svg-preview.sh source/mimetypes/application-x-jsp.svg` works too. Again, this is only needed if you want to uncomment one of the `<use>` tags at the bottom of the file to view the borders or grid.

