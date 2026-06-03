# Slack Scripts

## Usage with Triggers

You can use the `Send-PSUSlackNotification` function to send a message to a Slack channel. It automatically processes trigger data to send formatted messages.

```powershell
New-PSUTrigger -TriggerScript 'Devolutions.PowerShellUniversal.Triggers.Slack\Send-PSUSlackNotification' -EventType JobFailed
```

![Slack Notification](https://raw.githubusercontent.com/devolutions/powershell-universal-gallery/main/Triggers/Slack/images/notification.png)
