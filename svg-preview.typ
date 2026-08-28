// SVG previewer using Typst
// Can resolve import statements within SVG files
// where an SVG file has `<!-- #include path/to/file.svg -->`
// and the file is inserted as-is (including <svg> tags if present) at that location
//
// - All files must be in the project tree, or Typst cannot open them
// - Relative include paths (`path/to/file.svg` or `./path/to/file.svg`) are resolved
//   starting at the SVG file's path
// - Absolute include paths (`/path/to/file.svg`) are resolved from the Typst file
//
// Currently, includes in included files are not resolved
// Only Posix filepaths are supported

#set text(font: ("Trebuchet MS",))

//#let background = none
#let background = gradient.linear(
  (luma(170), 0%),
  (luma(170), 50%),
  (luma(200), 50%),
  (luma(200), 100%),
  angle: 45deg).repeat(50, mirror: true)
#let border = 1pt + gray

#let resolve-filepath(source-path, include-path) = {
  let incl = include-path.trim()
  if incl.starts-with("/") {
    // Absolute path
    return path(incl)
  } else {
    let path-components = source-path.split("/")
    let _ = path-components.pop()
    return path-components.join("/") + "/" + incl
  }
}

#let build-svg(path) = {
  let image-data = read(path)
  let include-statements = image-data.matches(regex("<!--\\s*#include\\s+([^>]+)\\s*-->"))

  let offset = 0
  for st in include-statements {
    // text[#st]
    let include-data = read(resolve-filepath(path, st.captures.at(0)))
    image-data = image-data.slice(0, st.start + offset) + include-data + image-data.slice(st.end + offset)
    offset += include-data.len() - st.text.len()
  }

  return bytes(image-data)
}

// Start document
#{
  let svg-file = sys.inputs.at("file", default: none)
  if svg-file == none {
    align(center)[
      #text(red)[*Please provide a file to preview using '--input file=path/to/file.svg'*]
    ]
  } else {
    text(gray)[Preview of file: #raw(svg-file)]
    box(stroke: border, fill: background, image(build-svg(svg-file), width: 100%))
    // [#build-svg(svg-file)]
    // [#sys.inputs]
  }
}
