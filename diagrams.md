# Diagrams

Diagrams are key for top architects and engineers.

> The ability to create meaningful diagrams is the pinnacle of communication skills as an engineer

There are GUI architecture tools, but they tend to be more difficult to reproduce, you're often starting from scratch for each client.

The cutting edge is Diagrams-as-Code.

<!-- INDEX_START -->

- [Real World Architecture Diagrams](#real-world-architecture-diagrams)
- [Templates](#templates)
- [Diagrams-as-Code Languages](#diagrams-as-code-languages)
- [GUI / Online Diagrams tools](#gui--online-diagrams-tools)
- [Icons](#icons)
  - [D2lang Icons](#d2lang-icons)
  - [Python Diagrams Icons](#python-diagrams-icons)
  - [Kubernetes & CNCF Icons](#kubernetes--cncf-icons)
  - [Cloud Provider Icons](#cloud-provider-icons)
  - [Other Icon Sets](#other-icon-sets)
  - [Icon Tips](#icon-tips)
- [Interactive Playground Editors](#interactive-playground-editors)
- [GraphViz](#graphviz)
- [Hex Colour Codes](#hex-colour-codes)
- [Diagram Design](#diagram-design)
  - [Complexity](#complexity)
- [Diagram of Diagrams-as-Code Tools](#diagram-of-diagrams-as-code-tools)
- [UML Class Diagrams](#uml-class-diagrams)
- [Graph Generation Repos](#graph-generation-repos)

<!-- INDEX_END -->

See also the [Documentation](documentation.md) and [Markdown](markdown.md) pages for tips on things like embedding
diagrams in `README.md`, as well Badges.

## Real World Architecture Diagrams

[HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) - ready made architecture diagrams

Mainly D2lang, Python diagrams, MermaidJS, GNUplot and a little Draw.io / LucidChart.

[GitHub Actions](github-actions.md) CI/CD pipelines auto-regenerate the diagrams upon any code changes and they appear
directly in the rendered README.md as the resultant `.png` images are sourced in the markdown code.

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Diagrams-as-Code&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Diagrams-as-Code)

## Templates

[Templates](https://github.com/HariSekhon/Templates) for D2 language and Python diagrams are found here, especially
[diagram.d2](https://github.com/HariSekhon/Templates/blob/master/diagram.d2) and
[diagram.py](https://github.com/HariSekhon/Templates/blob/master/diagram.py).

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=Templates&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/Templates)

## Diagrams-as-Code Languages

[Text-to-Diagram Comparison Playground](https://text-to-diagram.com/)

Diagrams-as-Code are both cool, easier to reuse prior work and often easier to maintain.

A quick edit and they reshuffle themselves.

The lack of placement layout control (D2 issue [#1285](https://github.com/terrastruct/d2/issues/1285),
Python Diagrams issues
[#44](https://github.com/mingrammer/diagrams/issues/44) and [#819](https://github.com/mingrammer/diagrams/issues/891))
is the main problem on more complex diagrams, for which you may want to switch to one of the top GUI tools from the
next section.

- [MermaidJS](https://mermaid.js.org/) - excellent multi-format flexible diagram language with code rendering directly
  inside GitHub markdown (`README.md`) files thanks to GitHub integration
  - see [MermaidJS](mermaidjs.md) doc page for details
- [D2 lang](https://d2lang.com/) - excellent, easy to use DSL for Cloud & Architecture diagrams, my favourite
  - See [D2 lang](d2.md) doc page for details
  - See thse D2 [Code](https://github.com/search?q=repo%3AHariSekhon%2FDiagrams-as-Code+path%3A*.d2&type=code) files
- [Python Diagrams](https://diagrams.mingrammer.com/) - my prior favourite
  - good for basic Cloud & Architecture diagrams with icons
  - See thse Python Diagrams [Code](https://github.com/search?q=repo%3AHariSekhon%2FDiagrams-as-Code+path%3A*.py&type=code) files
- [GraphViz](https://graphviz.org/) - the classic
  - its `dot` format is output by [Terraform](terraform.md)'s `terraform graph` command
  - this is the technology under the hood of Python diagrams above which makes it easier to use for Pythonistas
- [GNUplot](http://www.gnuplot.info/) - classic code diagram CLI tool that can plot from data files in different formats
  and output in many different formats
  - See these GNUplot [Code](https://github.com/search?q=repo%3AHariSekhon%2FDiagrams-as-Code+path%3A*.gnuplot&type=code) files
- [Go Diagrams](https://github.com/blushft/go-diagrams) - Golang a port of Python Diagrams
- [Cloudgram](https://cloudgram.dedalusone.com/index.html) - another DSL language
- [Structurizer](https://structurizr.com/dsl) - C4 architecture diagrams
- [PlantUML](https://plantuml.com/) - creates UML diagrams eg. class diagrams, sequence diagrams, use case diagrams
- [MarkMap](https://github.com/markmap/markmap) - visualize your Markdown as mindmaps, nice, can open your GitHub repo's
  Markdown directly, although it looks like my
  [DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)
  repo is far too huge a
  [map](https://markmap.js.org/repl#?d=github%3AHariSekhon%2FDevOps-Bash-tools%40master%3AREADME.md)

[Best Comparison Site](https://text-to-diagram.com/) (run by D2)

## GUI / Online Diagrams tools

For more control and complex architecture diagrams.

- [Draw.io](https://app.diagrams.net) - mature and can export to XML
  - integrates with Confluence to embed diagrams straight into Confluence wiki pages
- [LucidChart](https://lucid.app/) - used this for a GCP architecture diagram for a startup interview (I got the job)
  - pre-made VPC, region, zones - quicker to start
- [CloudCraft](https://app.cloudcraft.co/) - cloud focused diagrams
  - still only AWS and Azure diagrams as of March 2024
- [Creately](https://app.creately.com/) - AWS, Azure and GCP diagrams
- [Excalidraw](https://excalidraw.com/) - simple whiteboard style drawings - also useful for ad-hock drawings to explain things to colleagues
- [Miro](https://miro.com/app/dashboard/) - collaborative workflow and diagram tool
- [Prezi](https://prezi.com/) - focused on presentations
- [Sketch](https://www.sketch.com/)
- [Cacoo](https://nulab.com/cacoo/)
- [Gliffy](https://www.gliffy.com/)
- [Visual Paradigm](https://www.visual-paradigm.com/) - enterprise, does archimate diagrams, complicated, I used this at an investment bank, not my favourite, fine for enterprise architects rather than engineers
- [Cloudairy](https://chart.cloudairy.com/cloudchart) - new, buggy UI when I tried it
- [Swimm](https://docs.swimm.io/) - AI to generate diagrams from code and documentation sources

## Icons

### D2lang Icons

- [D2 Icons](https://icons.terrastruct.com/) - limited set, borrow some from Python Diagrams below

### Python Diagrams Icons

Python Diagrams has the best in-built library, some highlights are below, but check their adjacent categories too:

- [Python Diagrams On-Premise](https://diagrams.mingrammer.com/docs/nodes/onprem) - open source, databases, big data analytics, CI/CD etc.
- [Python Diagrams AWS](https://diagrams.mingrammer.com/docs/nodes/aws)
- [Python Diagrams GCP](https://diagrams.mingrammer.com/docs/nodes/gcp)
- [Python Diagrams Azure](https://diagrams.mingrammer.com/docs/nodes/azure)
- [Python Diagrams Generic](https://diagrams.mingrammer.com/docs/nodes/generic) - OS, Virtualization, Network Hardware
- [Python Diagrams Kubernetes](https://diagrams.mingrammer.com/docs/nodes/k8s)
- [Python Diagrams SaaS](https://diagrams.mingrammer.com/docs/nodes/saas)
  - Snowflake
  - CDNs eg. Akamai, Cloudflare, Fastly
  - IdP eg. Okta, Auth0
  - Monitoring & Alerting eg. Datadog, Newrelic, Pagerduty

### Kubernetes & CNCF Icons

- [Official Kubernetes Icons](https://github.com/kubernetes/community/tree/master/icons)

<!-- -->

- [CNCF technologies Icons](https://landscape.cncf.io/card-mode)

<!-- -->

### Cloud Provider Icons

- [Official AWS Icons](https://aws.amazon.com/architecture/icons/)

<!-- -->

- [Official GCP Icons](https://cloud.google.com/icons)

<!-- -->

- [Official Azure Icons](https://learn.microsoft.com/en-us/azure/architecture/icons/)

### Other Icon Sets

- [SimpleIcons](https://simpleicons.org/) - famous for use with [Shield.io](markdown.md#shieldsio) for badging GitHub repos

<!-- -->

- [Benco Azure Icons](https://code.benco.io/icon-collection/azure-icons/)
- [Icon8 Azure Icons](https://icons8.com/icons/set/azure)

<!-- -->

- [SVGrepo](https://www.svgrepo.com/) - 500,000 SVG icons

<!-- -->

- [World Vector Logo](https://worldvectorlogo.com/) - these silently fail to import into D2 resulting in diagrams with
  missing icon placeholders
  ([terrastruct/d2 issue 2367](https://github.com/terrastruct/d2/issues/2367))

<!-- -->

- [FlatIcon](https://www.flaticon.com/)

<!-- -->

- [IconFinder](https://www.iconfinder.com/)

<!-- -->

- [Icons8](https://icons8.com/)

<!-- -->

- [FreebieSupply logos](https://freebiesupply.com/logos/)

<!-- -->

- [Iconify.design](https://icon-sets.iconify.design/) - Massive 200,000 open source SVG icon set

<!-- -->

- [SeekLogo](https://seeklogo.com/) - gives icons as zip, less useful for Diagrams-as-Code

<!-- -->

- [IconDuck](https://iconduck.com/) - doesn't give direct download links you can use in Diagrams-as-Code

### Icon Tips

If all else fails, there is always [Google Image Search](https://images.google.com/).

Some sites use funny tricks to stop you having direct download links.

If you Google Image search and just right-click and Open Image in New Tab, you'll get a direct asset link to a CDN or
similar you can use.

However, CDN asset links tend to disappear after some months / years when websites get updated, so you should download and
commit the source icon to your repo when using it in Diagrams-as-Code to prevent future time-wasting breakages.

## Interactive Playground Editors

[![Text-to-Diagram Comparison Playground](https://img.shields.io/badge/Text--To--Diagram-playground-4A6FF3?logo=pending&logoColor=white)](https://text-to-diagram.com/)
[![D2](https://img.shields.io/badge/D2-playground-4A6FF3?logo=pending&logoColor=white)](https://play.d2lang.com/)
[![MermaidJS](https://img.shields.io/badge/MermaidJS-Live%20Editor-FF3399.svg?logo=data:image/svg%2bxml;base64,PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+CjwhRE9DVFlQRSBzdmcgUFVCTElDICItLy9XM0MvL0RURCBTVkcgMS4xLy9FTiIgImh0dHA6Ly93d3cudzMub3JnL0dyYXBoaWNzL1NWRy8xLjEvRFREL3N2ZzExLmR0ZCI+Cjxzdmcgd2lkdGg9IjEwMCUiIGhlaWdodD0iMTAwJSIgdmlld0JveD0iMCAwIDQ5MSA0OTEiIHZlcnNpb249IjEuMSIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIiB4bWxuczp4bGluaz0iaHR0cDovL3d3dy53My5vcmcvMTk5OS94bGluayIgeG1sOnNwYWNlPSJwcmVzZXJ2ZSIgeG1sbnM6c2VyaWY9Imh0dHA6Ly93d3cuc2VyaWYuY29tLyIgc3R5bGU9ImZpbGwtcnVsZTpldmVub2RkO2NsaXAtcnVsZTpldmVub2RkO3N0cm9rZS1saW5lam9pbjpyb3VuZDtzdHJva2UtbWl0ZXJsaW1pdDoyOyI+CiAgICA8cGF0aCBkPSJNNDkwLjE2LDg0LjYxQzQ5MC4xNiwzNy45MTIgNDUyLjI0OCwwIDQwNS41NSwwTDg0LjYxLDBDMzcuOTEyLDAgMCwzNy45MTIgMCw4NC42MUwwLDQwNS41NUMwLDQ1Mi4yNDggMzcuOTEyLDQ5MC4xNiA4NC42MSw0OTAuMTZMNDA1LjU1LDQ5MC4xNkM0NTIuMjQ4LDQ5MC4xNiA0OTAuMTYsNDUyLjI0OCA0OTAuMTYsNDA1LjU1TDQ5MC4xNiw4NC42MVoiIHN0eWxlPSJmaWxsOnJnYigyNTUsNTQsMTEyKTsiLz4KICAgIDxwYXRoIGQ9Ik00MDcuNDgsMTExLjE4QzMzNS41ODcsMTA4LjEwMyAyNjkuNTczLDE1Mi4zMzggMjQ1LjA4LDIyMEMyMjAuNTg3LDE1Mi4zMzggMTU0LjU3MywxMDguMTAzIDgyLjY4LDExMS4xOEM4MC4yODUsMTY4LjIyOSAxMDcuNTc3LDIyMi42MzIgMTU0Ljc0LDI1NC44MkMxNzguOTA4LDI3MS40MTkgMTkzLjM1LDI5OC45NTEgMTkzLjI3LDMyOC4yN0wxOTMuMjcsMzc5LjEzTDI5Ni45LDM3OS4xM0wyOTYuOSwzMjguMjdDMjk2LjgxNiwyOTguOTUzIDMxMS4yNTUsMjcxLjQyIDMzNS40MiwyNTQuODJDMzgyLjU5NiwyMjIuNjQ0IDQwOS44OTIsMTY4LjIzMyA0MDcuNDgsMTExLjE4WiIgc3R5bGU9ImZpbGw6d2hpdGU7ZmlsbC1ydWxlOm5vbnplcm87Ii8+Cjwvc3ZnPgo=)](https://mermaid.live/edit)
[![GraphvizOnline](https://img.shields.io/badge/GraphViz-Online-5d6d7e?logo=pending&logoColor=white)](https://dreampuf.github.io/GraphvizOnline/)
[![CloudGram](https://img.shields.io/badge/CloudGram-editor-8B72C2?logo=pending&logoColor=white)](https://cloudgram.dedalusone.com/index.html)
[![PlantUML](https://img.shields.io/badge/PlantUML-editor-blue?logo=pending&logoColor=white)](https://www.planttext.com/)
[![Excalidraw](https://img.shields.io/badge/Excalidraw-editor-6965DB?logo=excalidraw&logoColor=white)](https://excalidraw.com/)
[![Miro](https://img.shields.io/badge/Miro-dashboard-FEDD33.svg?logo=miro)](https://miro.com/app/dashboard/)

- [Text-to-Diagram Comparison Playground](https://text-to-diagram.com/)
- [D2 lang](https://play.d2lang.com/)
- [MermaidJS](https://mermaid.live/)
- [GraphVizOnline](https://dreampuf.github.io/GraphvizOnline/)
- [CloudGram](https://cloudgram.dedalusone.com/index.html)
- GraphViz:
  - <https://dreampuf.github.io/GraphvizOnline>
  - <http://magjac.com/graphviz-visual-editor/>
  - <https://edotor.net/>
- [MarkMap Online REPL](https://markmap.js.org/repl)
- Draw.io:
  - [Draw.io pre-loaded with AWS, GCP and Azure icons](https://app.diagrams.net/?splash=0&ui=dark&libs=aws3;aws3d;aws4;azure;gcp2;network;webicons)
  - [Draw.io pre-loaded with AWS icons](https://app.diagrams.net/?splash=0&ui=dark&libs=aws3;aws3d;aws4)
  - [Draw.io pre-loaded with Azure icons](https://app.diagrams.net/?splash=0&ui=dark&libs=azure)
  - [Draw.io pre-loaded with GCP icons](https://app.diagrams.net/?splash=0&ui=dark&libs=gcp;gcp2)
  - [Supported URL parameters](https://www.drawio.com/doc/faq/supported-url-parameters) - to instantly load the above icon sets, set dark etc.
- [LucidChart](https://lucid.app/)
- [CloudCraft](https://app.cloudcraft.co/)
- [PlantUML](https://www.planttext.com/)
- [Excalidraw](https://excalidraw.com/)
- [Miro](https://miro.com/app/dashboard/)
- [Creately](https://app.creately.com/)
- [Visual Paradigm](https://online.visual-paradigm.com/)
  - [Online Dashboard](https://online.visual-paradigm.com/drive/#diagramlist:proj=0&dashboard)
- [Structurizer](https://structurizr.com/dsl)

## GraphViz

in [HariSekhon/Templates](https://github.com/HariSekhon/Templates)

generate `.png` using the `dot` command:

```shell
dot -T png template.gv -o file.png >/dev/null
```

open the generated `.png` file:

```shell
if uname -s | grep -q Darwin; then
  open file.png  # Mac
else
  sxiv file.png  # Linux
fi
```

or better use the `imageopen.sh` script from the [DevOps-Bash-tools](devops-bash-tools.md) repo
which tries more different tools on Linux to open the image:

[HariSekhon/DevOps-Bash-tools - imageopen.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/bin/imageopen.sh)

## Hex Colour Codes

See [Visualization](visualization.md) doc's [Colours](visualization.md#colours) section.

## Diagram Design

### Complexity

[Diagrams-as-Code](#diagrams-as-code-languages) languages currently have no placement control placement layout control
(D2 issue [#1285](https://github.com/terrastruct/d2/issues/1285),
Python Diagrams issues
[#44](https://github.com/mingrammer/diagrams/issues/44)
and [#819](https://github.com/mingrammer/diagrams/issues/891)).

This limits the complexity of diagrams that can be generated from code because they can very quickly get out of
control and ugly as a result, costing you lots of time trying to get them to generate sane looking diagrams.

For complex diagrams you really need to switch to [GUI tools](#gui--online-diagrams-tools) for better control.

However, that being said, one diagram can only become so complicated before it becomes difficult for humans to easily
interpret due to too much detail.

For this reason, I recommend favouring an approach of multiple levels of simpler diagrams:

- an architecture overview diagram
- sub-diagrams that drill down into the implementation details of the different components eg. how it runs on Kubernetes
  or with high availability

The diagrams can be more easily read one after another.

You see examples of diagrams at different levels of drill-down from architecture to Kubernetes components in the
[HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code/Diagrams-as-Code) repo.

Some components like Grafana and [Vault](vault.md) are very relevant in architecture diagrams
and should be present but can be represented by a since simple icon,
with their implementation showing how they're running on Kubernetes
or achieving high availability being left to separate diagrams for each one.

## Diagram of Diagrams-as-Code Tools

![Diagrams-as-Code tools](images/diagrams_tools.gif)

## UML Class Diagrams

![UML Class Diagrams Cheatsheet](images/uml_diagrams.gif)

## Graph Generation Repos

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=GitHub-Graph-Commit-Times&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/GitHub-Graph-Commit-Times)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=GitHub-Repos-MermaidJS-Gantt-Chart&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/GitHub-Repos-MermaidJS-Gantt-Chart)

**Ported from various private Knowledge Base pages 2020+**
