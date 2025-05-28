# PDF

<!-- INDEX_START -->

- [PDFly](#pdfly)
- [Extract Metadata](#extract-metadata)
- [Extract Pages from a PDF](#extract-pages-from-a-pdf)
- [Concatenate PDFs together](#concatenate-pdfs-together)
- [Convert Image to PDF](#convert-image-to-pdf)
- [Convert Text file to PDF](#convert-text-file-to-pdf)
  - [Pandoc](#pandoc)
  - [enscript + ps2pdf](#enscript--ps2pdf)
  - [textutil](#textutil)

<!-- INDEX_END -->

## PDFly

Utility to extract metadata, cut, splice or concatenate PDFs.

<https://pdfly.readthedocs.io/en/latest/>

```shell
brew install pdfly
```

## Extract Metadata

```shell
pdfly meta "$name.pdf"
```

## Extract Pages from a PDF

Works like Python list - indices start at zero.

This takes pages 2, 3 and 4 into `out.pdf`:

```shell
pdfly cat input.pdf 1:4 -o out.pdf
```

Extract the 5th page:

```shell
pdfly cat input.pdf 5 -o out.pdf
```

## Concatenate PDFs together

```shell
pdfly cat input1.pdf input2.pdf -o out.pdf
```

## Convert Image to PDF

```shell
pdfly x2pdf image.jpg -o out.pdf
```

## Convert Text file to PDF

### Pandoc

```shell
brew install pandoc
```

```shell
pandoc "$name.txt" -o "$name.pdf"
```

<!--

If you get this error:

```text
pdflatex not found. Please select a different --pdf-engine or install pdflatex
```

then install

```shell

```

-->

### enscript + ps2pdf

```shell
brew install enscript ghostscript
```

```shell
enscript "$name.txt" -o - | ps2pdf - "$name.pdf"
```

### textutil

Built in to macOS, but limited styling:

```shell
textutil -convert pdf "$name.txt" -output "$name.pdf"
```
