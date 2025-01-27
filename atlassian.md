# Atlassian

<https://www.atlassian.com/>

Atlassian is a proprietary software company that makes high quality easy to use developer tooling that are widely used
in corporate environments.

- [Confluence](https://www.atlassian.com/software/confluence) - wiki for [documentation](documentation.md)
  - easy to use, with integration with draw.io diagrams platform (see the Diagrams page)
- [Jira](https://www.atlassian.com/software/jira) - ticket / issue tracker
  - use a [pre-commit](pre-commit.md) git hook to require Jira ID or rejects commit
    - the commit then shows up in the Jira ticket on the right under Development
  - use a [CI/CD](cicd.md) workflow to require a Jira ID in Pull Request title or disallow merge
  - use a [TamperMonkey](tampermonkey.md) script to auto-populate the Jira description field with a template
- [FishEye](https://www.atlassian.com/software/fisheye) - visualize and report on any SCM history
- [Bitbucket](https://bitbucket.org/) - don't use this, it's a rare L for Atlassian, see the [CI/CD](cicd.md) page for
  more details
- [OpsGenie](opsgenie.md) - centralized alerting and escalation, incident management SaaS tool

For other products see the [Atlassian](https://www.atlassian.com/) home page.
