# TamperMonkey

Browser extension to modify the behaviour of web pages using scripts.

<!-- INDEX_START -->

- [Install TamperMonkey](#install-tampermonkey)
- [TamperMonkey Scripts](#tampermonkey-scripts)
  - [Tel to Whatsapp](#tel-to-whatsapp)
  - [Jira Description Autofill](#jira-description-autofill)
- [Script Sites](#script-sites)
  - [UserScript.Zone](#userscriptzone)
  - [Greasy Fork](#greasy-fork)
  - [OpenUserJS](#openuserjs)
- [Troubleshooting](#troubleshooting)
  - [Script Not Triggering](#script-not-triggering)
  - [No Scripts Are Triggering / Logging](#no-scripts-are-triggering--logging)

<!-- INDEX_END -->

## Install TamperMonkey

<https://www.tampermonkey.net/>

## TamperMonkey Scripts

Click the TamperMonkey extension -> `Create New Script` and then paste in the script from below:

### Tel to WhatsApp

Auto-converts `+tel:` links to WhatsApp clickable links for convenience on 3rd party websites.

[tel_to_whatsapp.js](https://github.com/HariSekhon/TamperMonkey/blob/main/tel_to_whatsapp.js)

### Jira Description Autofill

Auto-fills Jira description field with Agile template.

[jira_description_autofill.js](https://github.com/HariSekhon/TamperMonkey/blob/main/jira_description_autofill.js)

[![Readme Card](https://github-readme-stats.vercel.app/api/pin/?username=HariSekhon&repo=TamperMonkey&theme=ambient_gradient&description_lines_count=3)](https://github.com/HariSekhon/TamperMonkey)

## Script Sites

<https://www.tampermonkey.net/scripts.php>

### UserScript.Zone

<https://www.userscript.zone/>

### Greasy Fork

<https://greasyfork.org/en>

### OpenUserJS

Less focused than the above two resources.

Warning: some NSFW topics on here:

<https://openuserjs.org/>

## Troubleshooting

### Script Not Triggering

Check the `@match` line in the script matches the URL.

### No Scripts Are Triggering / Logging

Try adding a test script with the `@match` line and a simple:

```shell
console.log(`Test Script: Initializing...`);
```

and then look for this in your Chrome Developer Tools or equivalent Console area where the logs are shown.

If even this doesn't show up... then no scripts are executing on your `@match`.

After much time wasted debugging everything,
checking my [GitHub](https://github.com/HariSekhon/TamperMonkey) revision controlled script was the same as the one in
TamperMonkey, the solution was simple:

**Solution**: remove TamperMonkey and reinstall it to get scripts triggering again.
