# Jira

Jira tickets are widely used in enterprises to track work and plan sprints using standard Agile methodology.

<!-- INDEX_START -->

- [Jira Ticket Descriptions](#jira-ticket-descriptions)
  - [Auto-Populate Jira Description](#auto-populate-jira-description)

<!-- INDEX_END -->

## Jira Ticket Descriptions

Jira Ticket descriptions should have the following sections:

- Summary Description
  - What you want to do and why
- Acceptance Criteria
  - bullet points
- Engineering Notes & References
  - Notes
  - Design Decisions
  - URLs to references and relevant docs

### Auto-Populate Jira Description

To automate pre-populating the description field without requiring Admin privileges to Jira you can use a
[TamperMonkey](https://www.tampermonkey.net/)
script and tune the description content to suite your needs or preferences.

Here is one I wrote for personal portable use which you can just copy and paste
into your TamperMonkey browser extension:

[jira_description_autofill.js](https://github.com/HariSekhon/TamperMonkey/blob/main/jira_description_autofill.js)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=TamperMonkey&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/TamperMonkey)
