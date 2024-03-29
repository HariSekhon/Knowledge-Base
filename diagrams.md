# Diagrams

Diagrams are key for top architects and engineers.

> The ability to create meaningful diagrams is the pinnacle of communication skills as an engineer

There are GUI architecture tools, but they tend to be more difficult to reproduce, you're often starting from scratch for each client.

The cutting edge is Diagrams-as-Code.

## Real World Architecture Diagrams

[HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code) - ready made architecture diagrams

Mainly D2 and Python diagrams, with some MermaidJS and a little Draw.io / LucidChart.

## Templates

[Templates](https://github.com/HariSekhon/Templates) for D2 language and Python diagrams are found here, especially
[diagram.d2](https://github.com/HariSekhon/Templates/blob/master/diagram.d2) and
[diagram.py](https://github.com/HariSekhon/Templates/blob/master/diagram.py).

## Diagrams Languages

- [D2 lang](https://d2lang.com/) - excellent, easy to use DSL, my favourite
  - read [D2 lang](d2.md) for details
- [Python Diagrams](https://diagrams.mingrammer.com/) - my prior favourite
  - good for basic Cloud Architecture diagrams with icons
  - unfortunately no placement control for more complex diagrams
- [Go Diagrams](https://github.com/blushft/go-diagrams) - a port of Python Diagrams
- [Cloudgram](https://cloudgram.dedalusone.com/index.html) - another DSL language
- [GraphViz](https://graphviz.org/) - the classic
  - its `dot` format is output by [Terraform](terraform.md)'s `terraform graph` command
  - this is the technology under the hood of Python diagrams above which makes it easier to use for Pythonistas
- [MermaidJS](https://mermaid.js.org/) - best for embedded live diagrams in GitHub READMEs
  - Flow Chart, Git Commit Log Charts, Gantt diagrams etc.
  - not primarily icon oriented such as for Cloud Architecture diagrams (D2 and Python diagrams are better for that)
  - can do icons though, see [example](https://text-to-diagram.com/?example=icons&b=mermaid) by D2 comparison site
  - see [HariSekhon/Diagrams-as-Code](https://github.com/HariSekhon/Diagrams-as-Code)
repo for live embedded MermaidJS diagrams
[GitHub Flow with Jira integration](https://github.com/HariSekhon/Diagrams-as-Code/blob/master/README.md#github-flow-with-jira-ticket-integration)
and [Git Environment Branches](https://github.com/HariSekhon/Diagrams-as-Code/blob/master/README.md#git---environment-branches)
- [Structurizer](https://structurizr.com/dsl) - yet another DSL, limited to software models
- [MarkMap](https://github.com/markmap/markmap) - visualize your Markdown as mindmaps, nice, can open your GitHub repo's
Markdown directly, although it looks like my
[DevOps-Bash-tools](https://github.com/HariSekhon/DevOps-Bash-tools)
repo is far too huge a
[map](https://markmap.js.org/repl#?d=github%3AHariSekhon%2FDevOps-Bash-tools%40master%3AREADME.md)

[Best Comparison Site](https://text-to-diagram.com/) (run by D2)

## GUI / Online Diagrams tools

- [Draw.io](https://app.diagrams.net) - mature and can export to XML
  - integrates with Confluence to embed diagrams straight into Confluence wiki pages
- [LucidChart](https://lucid.app/) - used this for a GCP architecture diagram for a startup interview (I got the job)
  - pre-made VPC, region, zones - quicker to start
- [CloudCraft](https://app.cloudcraft.co/) - cloud focused diagrams
  - still only AWS and Azure diagrams as of March 2024
- [Creately](https://app.creately.com/) - AWS, Azure and GCP diagrams
- [Prezi](https://prezi.com/) - focused on presentations
- [Sketch](https://www.sketch.com/)
- [Cacoo](https://nulab.com/cacoo/)
- [Gliffy](https://www.gliffy.com/)
- [Visual Paradigm](https://www.visual-paradigm.com/) - enterprise, does archimate diagrams, complicated, I used this at an investment bank, not my favourite, fine for enterprise architects rather than engineers
- [Swimm](https://docs.swimm.io/) - AI to generate diagrams from code and documentation sources

## Important Icon Sets to import into D2

Python Diagrams has the best library, some highlights are below but check their adjacent categories too:

- [D2 Icons](https://icons.terrastruct.com/)


- [Python Diagrams On-Premise](https://diagrams.mingrammer.com/docs/nodes/onprem)
- [Python Diagrams AWS](https://diagrams.mingrammer.com/docs/nodes/aws)
- [Python Diagrams GCP](https://diagrams.mingrammer.com/docs/nodes/gcp)
- [Python Diagrams Azure](https://diagrams.mingrammer.com/docs/nodes/azure)
- [Python Diagrams Generic](https://diagrams.mingrammer.com/docs/nodes/generic) - OS, Virtualization, Network Hardware
- [Python Diagrams Kubernetes](https://diagrams.mingrammer.com/docs/nodes/k8s)


- [Official Kubernetes Icons](https://github.com/kubernetes/community/tree/master/icons)



- [CNCF technologies Icons](https://landscape.cncf.io/card-mode)


- [SimpleIcons](https://simpleicons.org/)


- [FlatIcon](https://www.flaticon.com/)


- [IconFinder](https://www.iconfinder.com/)


- [Icons8](https://icons8.com/)


- [Official AWS Icons](https://aws.amazon.com/architecture/icons/)


- [Official GCP Icons](https://cloud.google.com/icons)


- [Official Azure Icons](https://learn.microsoft.com/en-us/azure/architecture/icons/)
- [Benco Azure Icons](https://code.benco.io/icon-collection/azure-icons/)
- [Icon8 Azure Icons](https://icons8.com/icons/set/azure)

### Interactive Playground Editors

- [D2 lang](https://play.d2lang.com/)
- [MermaidJS](https://mermaid.live/)
- [CloudGram](https://cloudgram.dedalusone.com/index.html)
- GraphViz:
  - https://dreampuf.github.io/GraphvizOnline
  - http://magjac.com/graphviz-visual-editor/
  - https://edotor.net/
-[MarkMap](https://markmap.js.org/repl)
- Draw.io:
  - [Draw.io pre-loaded with AWS, GCP and Azure icons](https://app.diagrams.net/?splash=0&ui=dark&libs=aws3;aws3d;aws4;azure;gcp2;network;webicons)
  - [Draw.io pre-loaded with AWS icons](https://app.diagrams.net/?splash=0&ui=dark&libs=aws3;aws3d;aws4)
  - [Draw.io pre-loaded with Azure icons](https://app.diagrams.net/?splash=0&ui=dark&libs=azure)
  - [Draw.io pre-loaded with GCP icons](https://app.diagrams.net/?splash=0&ui=dark&libs=gcp;gcp2)
- [LucidChart](https://lucid.app/)
- [CloudCraft](https://app.cloudcraft.co/)
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

###### Ported from various private Knowledge Base pages 2020+
