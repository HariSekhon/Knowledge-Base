# Visualization

Graphs make life pretty.

<!-- INDEX_START -->

- [Python Libraries](#python-libraries)
- [Colours](#colours)
  - [Hex Colour Chart Sites](#hex-colour-chart-sites)
  - [Detecting Colours - ColorZilla](#detecting-colours---colorzilla)
  - [Terminal Colors Programs](#terminal-colors-programs)

<!-- INDEX_END -->

## Python Libraries

See the [Python](python.md) doc's [Data Visualization](python.md#data-visualization) section.

## Colours

### Hex Colour Chart Sites

For customization, especially in chart visualizations rather than icon-based [Diagrams-as-Code](diagrams.md),
or when changing background colours:

<https://www.rapidtables.com/web/color/RGB_Color.html>

<https://htmlcolorcodes.com/>

### Detecting Colours - ColorZilla

You can pick the colour of an image or logo off a web page using [ColorZilla](https://www.colorzilla.com/).

Install the [Chrome extension](https://chrome.google.com/webstore/detail/bhlhnicpbhignbdhedgjhgdocnmhomnp) or Firefox
extension and then just click the extension icon, picker and choose an icon or image or area from the web page.

For example, I used this to find out the exact yellow colour of the [Miro.com](https://miro.com) logo as `FEDD33`.

This would be hard to determine by guessing the colour, and if you just picked the generic `yellow` colour it would come
out as this:

[![Miro](https://img.shields.io/badge/Miro-dashboard-yellow.svg?logo=miro)](https://miro.com/app/dashboard/)

Whereas with the hex colour detection of the exact hex code of `FEDD33` it comes out as this, which is a very diffferent
yellow:

[![Miro](https://img.shields.io/badge/Miro-dashboard-FEDD33.svg?logo=miro)](https://miro.com/app/dashboard/)

### Terminal Colors Programs

I wrote a couple programs to show basic colours on the terminal background vs foreground:

[HariSekhon/DevOps-Golang-tools - colors.go](https://github.com/HariSekhon/DevOps-Golang-tools/blob/master/colors.go)

[HariSekhon/DevOps-Perl-tools - colors.pl](https://github.com/HariSekhon/DevOps-Perl-tools/blob/master/colors.pl)
