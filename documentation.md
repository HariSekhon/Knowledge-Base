# Documentation

- [The Importance of Documentation](#the-importance-of-documentation)
- [Documentation Tools](#documentation-tools)
  - [Wikis](#wikis)
- [Documentation-as-Code](#documentation-as-code)
  - [Markdown, GitHub, `README.md`](#markdown-github-readmemd)
- [Datacenter Documentation](#datacenter-documentation)
  - [Rack Documentation](#rack-documentation)
  - [IPAM - IP Address Management](#ipam---ip-address-management)

## The Importance of Documentation

If you've ever had this _"Why Bother?"_ approach to documentation, allow me to give you the benefit of hindsight:

1. Your memory is simply not good enough for the volume of tech that exists today.


2. Build a great team and hand stuff off to them so you can move on to the next interesting thing,
there's already too much to do for one human lifetime.


3. Holidays - if you ever want time off without interruptions,
you need to document how to cover what you're doing.


4. Hoarding knowledge doesn't give you job security anyway.
   Working on the next cool thing for your client or employer does.


## Documentation Tools

### Wikis

Wikis are the simplest way to do documentation - they are point and click (and type of course).

There are many different Wiki softwares:

- [Confluence](https://www.atlassian.com/software/confluence) - proprietary but widely used by corporations,
  easy to use, with integration with [draw.io](https://app.diagrams.net/) diagrams platform
  (see the [Diagrams](diagrams.md#gui--online-diagrams-tools) page)
- [MediaWiki](https://www.mediawiki.org/) - written to power the world famous Wikipedia
- [DokuWiki](https://www.dokuwiki.org/dokuwiki) - simple open-source wiki
- [GitHub Wiki](https://docs.github.com/en/communities/documenting-your-project-with-wikis) -
  every GitHub repo comes with one, but seriously, who uses this when there is
  [GitHub Markdown](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax)
  (`README.md` - see [Documentation-as-Code](documentation-as-code.md))
  - [GitLab](https://docs.gitlab.com/ee/user/project/wiki/) and
  [Azure DevOps](https://learn.microsoft.com/en-us/azure/devops/project/wiki/wiki-create-repo?view=azure-devops)
  also have Wikis, but see [CI/CD](ci-cd.md) for why not to bother with those platforms any more

and too many other minor open source ones to list.

Ping me if there is a great popular open source one you think deserves to be listed here.

## Documentation-as-Code

### Markdown, GitHub, `README.md`

Document right in your Git repo as `README.md` and have your Git repo hosting platform render it as your repo's home
page - put links in it to your other markdown `*.md` doc files in your repo.

See [Documentation-as-Code](documentation-as-code.md) page.

## Datacenter Documentation

### Rack Documentation

- [RackMonkey](http://flux.org.uk/projects/rackmonkey/) - rudimentary open source tool for documenting rack server layout
- [RackTables](https://www.racktables.org/) - open source datacenter asset management, including hardware, networks and
  IP addresses
- [NetBox](https://netboxlabs.com/oss/netbox/) - open source DCIM and IPAM

### IPAM - IP Address Management

- [InfoBlox](https://www.infoblox.com/) - all-in-one IPAM management