# Documentation

<!-- INDEX_START -->

- [The Importance of Documentation](#the-importance-of-documentation)
- [Documentation Tips](#documentation-tips)
- [Documentation Tools](#documentation-tools)
  - [Wikis](#wikis)
- [Documentation-as-Code](#documentation-as-code)
  - [Markdown, GitHub, `README.md`](#markdown-github-readmemd)
  - [MKDocs](#mkdocs)
  - [Quarto](#quarto)
- [Datacenter Documentation](#datacenter-documentation)
  - [Rack Documentation](#rack-documentation)
  - [IPAM - IP Address Management](#ipam---ip-address-management)
- [Support Numbers](#support-numbers)
  - [WhatsApp Desktop Links](#whatsapp-desktop-links)
- [Animated GIF images of running commands](#animated-gif-images-of-running-commands)
- [Meme](#meme)

<!-- INDEX_END -->

## The Importance of Documentation

If you've ever had this _"Why Bother?"_ approach to documentation, allow me to give you the benefit of hindsight:

1. Your memory is simply not good enough for the volume of tech that exists today.

<!-- -->

2. Build a great team and hand stuff off to them so you can move on to the next interesting thing,
   there's already too much to do for one human lifetime.

<!-- -->

3. Holidays - if you ever want time off without interruptions, you need to document how to cover what you're doing.

<!-- -->

4. Hoarding knowledge doesn't give you job security anyway.
   Working on the next cool thing for your client or employer does.

<!-- -->

5. You can't search for things if you don't know they exist or what the terminology is.

## Documentation Tips

- Use simple clear language
  - you're not here to be a fancy author
- Explain Why
  - give design reasonings and context behind decisions, trade-offs, chain of thought etc.
  - Example: at a Hedge Fund I worked for, they evaluated [Confluent](confluent.md) platform but found it would have
    cost them \$1M annually in licensing so they chose to go with open source [Kafka](kafka.md) instead and just spent
    3 months of engineer time on it, which unfortunately for us is not worth anywhere near \$1M!
- Show examples and practical code snippets
- Show use cases and real-world scenarios
- Add [Diagrams](diagrams.md) and screenshots where you can to aid visually
- Reference links to official documentation and related resources, blogs and articles with more details -
  you don't have to duplicate everything when a link will do
- Keep docs up to date with changes
  - docs in [Markdown](markdown.md) should be edited along with the corresponding code changes in PRs
    - otherwise the PRs should be rejected
- Organize in an intuitive way, use Indexes with links to anchor headings along the page for easy navigation
  - see
    [markdown_generate_index.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/git/markdown_generate_index.sh)
    and
    [markdown_replace_index.sh](https://github.com/HariSekhon/DevOps-Bash-tools/blob/master/git/markdown_replace_index.sh)
    scripts from the [DevOps-Bash-tools](devops-bash-tools.md) repo.
- Consistent uniform style and formatting
- if referencing a GitHub code line number or HTML anchor, use
  [permalinks](github.md#use-permalink-url-references-for-documentation-or-support-issues)
  with the commit hash to avoid branch changes resulting in pointing to the wrong line or anchor reference in future

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
  (`README.md` - see [Markdown](markdown.md) tips page)
  - [GitLab](https://docs.gitlab.com/ee/user/project/wiki/) and
  [Azure DevOps](https://learn.microsoft.com/en-us/azure/devops/project/wiki/wiki-create-repo?view=azure-devops)
  also have Wikis, but see [CI/CD](ci-cd.md) for why not to bother with those platforms any more

and too many other minor open source ones to list.

Ping me if there is a great popular open source one you think deserves to be listed here.

## Documentation-as-Code

### Markdown, GitHub, `README.md`

Document right in your Git repo as `README.md` and have your Git repo hosting platform render it as your repo's home
page - put links in it to your other markdown `*.md` doc files in your repo.

See the [Markdown](markdown.md) page.

### MKDocs

[MKDocs](mkdocs.md) turns [Markdown](markdown.md) into web pages.

### Quarto

<https://quarto.org/>

Write in [Markdown](markdown.md) with dynamic content in languages like Python.

Publish reproducible, production quality articles, presentations, dashboards, websites, blogs, and books in HTML, PDF,
MS Word, ePub etc.

Publish to Posit Connect, Confluence, or other publishing systems.

Can write using Pandoc markdown, including equations, citations, crossrefs, figure panels, callouts, advanced layout
etc.

## Datacenter Documentation

### Rack Documentation

- [RackMonkey](http://flux.org.uk/projects/rackmonkey/) - rudimentary open source tool for documenting rack server layout
- [RackTables](https://www.racktables.org/) - open source datacenter asset management, including hardware, networks and
  IP addresses
- [NetBox](https://netboxlabs.com/oss/netbox/) - open source DCIM and IPAM

### IPAM - IP Address Management

- [InfoBlox](https://www.infoblox.com/) - all-in-one IPAM management

## Support Numbers

Every team should maintain a Wiki or Git Readme markdown table of support numbers for the Primary,
Secondary and, if exists, Tertiary supporters for each project or track.

This should be bookmarked by every supporting team member and manager
to reach out for help in case people are not in their ChatOps channels of Slack or Microsoft Teams during urgent
production support requests (people have lives, go to lunch, sleep, holidays etc.)

This also incentivizes people to thoroughly document all knowledge and commands needed to operate the technologies they
have implemented or support so that they don't have to get calls during their free time...
what free time I hear you say? 😅

### WhatsApp Desktop Links

Support mobile phone numbers should be created as WhatsApp links to allow one-click opening of chats in
[WhatsApp Desktop](https://www.whatsapp.com/download)
for convenience:

```web
https://wa.me/<PhoneNumber>
```

where `<PhoneNumber>` should include the country code without the leading `00` or `+` eg. for `+447769991234` it would be:

```web
https://wa.me/447769991234
```

This is not my real number. Recruiters please do not call it.

Also, if you have my real number, please do not call it.

Always message me on [LinkedIn](https://www.linkedin.com/in/HariSekhon) instead after reading my profile's summary
bullet point criteria - it'll give you nearly everything you need to know about my availability and preferences.

## Animated GIF images of running commands

If you want to get fancy:

<https://github.com/faressoft/terminalizer>

## Meme

![senior_guides_and_teaches](images/non_toxic_senior_who_guides_and_teaches_me_I_will_fight_for_you.jpeg)

**I may well call upon you to defeat tedious Agile ceremonies!**
