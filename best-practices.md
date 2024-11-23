# IT Best Practices

<!-- INDEX_START -->

- [Budget vs Reality](#budget-vs-reality)
- [High Availability and Multi-Datacenter](#high-availability-and-multi-datacenter)
- [Use Version Control for Everything Textual - Code, Configs & Docs](#use-version-control-for-everything-textual---code-configs--docs)
- [Releases](#releases)
  - [Do not do production releases on Friday afternoons or after 4pm any day](#do-not-do-production-releases-on-friday-afternoons-or-after-4pm-any-day)
- [Versioning](#versioning)
  - [Use a sane versioning system](#use-a-sane-versioning-system)
    - [Software Versioning](#software-versioning)
    - [Live Websites / SaaS](#live-websites--saas)
- [Automation](#automation)
- [Kubernetes - Production Ready Checklist](#kubernetes---production-ready-checklist)
- [Documentation](#documentation)
- [Principle: Time Amplification Effect](#principle-time-amplification-effect)

<!-- INDEX_END -->

## Budget vs Reality

Make sure the money you intend to spend on IT is worth it.

There is no point doing gold-plated multi-datacenter setups that take you forever to implement on salary/contractor time
if the value of the service being offline is negligible.

Big online businesses like social media companies,
ad tech and trading can lose a fortune
and so there it's worth **Sparing No Expense**
because the cost of the IT will usually be far less than the cost of a single outage:

![Jurassic Park - Spared No Expense](images/jurassic_park_spared_no_expense.jpeg)

## High Availability and Multi-Datacenter

Ensure every service should have redundancy at both the:

- local service level (server clustering) and
- across datacenters in different geographical locations
  - in case there is a :
    - natural disaster or
    - power cut at one geographic location

The cost of doing this must be balanced against the value of the service - see [Budget vs Reality](#budget-vs-reality).

Sometimes it's better to just live with the lack of redundancy if the cost outweighs the value.

## Use Version Control for Everything Textual - Code, Configs & Docs

Put everything in [Git](git.md).

Don't waste your time on other legacy version control systems.

GitHub README [Markdown](markdown.md) files and [MkDocs](mkdocs.md) mean you can track all your documentation changes
easily using [Git](git.md) just like you do for your code & configs.

For techies, this is better than relying on a separate proprietary mechanism than [Confluence](atlassian.md).

You can even do your [Diagrams-as-Code](diagrams.md) and store them in Git too.

Even if you have to do diagrams in Draw.io or WYSIWYG tool, often they can export XML.
Backport that XML to Git to revision control it to track changes over time
and be able to revert if you messed something up.

## Releases

### Do not do production releases on Friday afternoons or after 4pm any day

People want to go home and enjoy their lives, not be stuck debugging problems you've caused.

## Versioning

### Use a sane versioning system

#### Software Versioning

For published software use the [semver](https://semver.org/) standard.

#### Live Websites / SaaS

For websites, the versioning can be something simple and predictable like `YYYY.NN` format for simplicity
since you're probably doing trunk based development and only roll forwards to fix issues.

Example the first release in the year 2024 is simply `202401`.

Estimate how many releases you'll do in a year
and pad the `NN` to that many digits so the versions stay lexically aligned.

## Automation

Your work isn't production grade until it's automated with tools like [Terraform](terraform.md), [Ansible](ansible.md),
or other code whereever possible.

## Kubernetes - Production Ready Checklist

See the [Kubernetes Production Ready Checklist](kubernetes-production-ready-checklist.md) doc.

## Documentation

Write a quick cheatsheet documentation page for everything you do.

There should be 1 page on every official technology and every internal project.

If it takes me more than 5-10 mins for me to see what you've done, then you've not done a good enough job.

## Principle: Time Amplification Effect

Do not waste your colleagues time.

If you've spent hours reading through a vendor's code base of Terraform code they want you to deploy
or retrofit to your AWS environment, then write a 1 page summary on it so
all your colleagues don't have to waste their time repeating the same work!
