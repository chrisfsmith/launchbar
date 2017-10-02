## Jira Summary
[LaunchBar](https://www.obdev.at/products/launchbar/index.html) extension to return the Jira issue key and summary in the format:
```
KEY: Summary
```

## What it does:
Uses the Jira REST API to lookup the issue summary. Helpful for filling in git commit subjects.

You'll need to copy `jira_sum.yaml.sample` from [jira-summary](https://github.com/chrisfsmith/jira-summary) to `~/.jira_sum.yaml`, and then edit it as appropriate.

## Usage Examples:
    1. Find the action by typing **jsum** in LaunchBar
    2. `SPACE` or `ENTER` to type the Jira ticket you want the summary for

## Release Notes:
* 1.0: Initial
