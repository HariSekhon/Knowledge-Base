# IT Best Practices

<!-- INDEX_START -->

- [Budget vs Reality](#budget-vs-reality)
- [High Availability and Multi-Datacenter](#high-availability-and-multi-datacenter)
- [Use Version Control for Everything Textual - Code & Configs](#use-version-control-for-everything-textual---code--configs)
- [Releases](#releases)
  - [Do not do production releases after 4pm or on Friday afternoons](#do-not-do-production-releases-after-4pm-or-on-friday-afternoons)
  - [Use a sane versioning system](#use-a-sane-versioning-system)
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

Ensure every service has redundancy at both the:

- local service level (server clustering) and
- across datacenters in different geographical locations
  - in case there is a :
    - natural disaster or
    - power cut at one geographic location

The cost of doing this must be balanced against the value of the service - see [Budget vs Reality](#budget-vs-reality).

## Use Version Control for Everything Textual - Code & Configs

Put everything in [Git](git.md).

Don't waste your time on other legacy version control systems.

## Releases

### Do not do production releases after 4pm or on Friday afternoons

People want to go home and enjoy their lives, not be stuck debugging problems you've caused

### Use a sane versioning system

- for published software that means [semver](https://semver.org/)
- for website, it can be YYYY.NN format for simplicity since you're probably doing trunk based development
  and only roll forwards to fix issues

## Kubernetes - Production Ready Checklist

See [Kubernetes](kubernetes-production-ready-checklist.md)

## Documentation

Write quick cheatsheet documentation for everything you do.

There should be 1 page on everything.

If it takes me more than 5-10 mins to see what you've done, then you've not done a good enough job.

## Principle: Time Amplification Effect

Do not waste your colleagues time. If you've spent hours reading through a vendor's code base of Terraform code they want you to deploy or retrofit to your environment, write a 1 page summaary on it so all your colleagues don't have to waste their time repeating the same work.
