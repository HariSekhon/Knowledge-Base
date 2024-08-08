# Atlassian

<https://www.atlassian.com/>

Atlassian is a proprietary software company that makes high quality easy to use developer tooling that are widely used
in corporate environments.

- [Confluence](https://www.atlassian.com/software/confluence) - wiki for [documentation](documentation.md)
  - easy to use, with integration with draw.io diagrams platform (see the Diagrams page)
- [Jira](https://www.atlassian.com/software/jira) - ticket / issue tracker
  - use a [pre-commit](pre-commit.md) git hook to require Jira ID or rejects commit
    - the commit then shows up in the Jira ticket on the right under Development
  - use a [CI/CD](ci-cd.md) workflow to require a Jira ID in Pull Request title or disallow merge
- [FishEye](https://www.atlassian.com/software/fisheye) - visualize and report on any SCM history
- [Bitbucket](https://bitbucket.org/) - don't use this, it's a rare L for Atlassian, see the [CI/CD](ci-cd.md) page for
  more details

For other products see the [Atlassian](https://www.atlassian.com/) home page.
