# Discord Trigger Scripts

![Discord Notification](https://raw.githubusercontent.com/ironmansoftware/scripts/main/Triggers/PowerShellUniversal.Triggers.Discord/images/notification.png)

## Usage with Triggers

You can use the `Send-PSUDiscordNotification` function to send a message to a Discord channel. It automatically processes trigger data to send formatted messages.

```powershell
New-PSUTrigger -TriggerScript 'PowerShellUniversal.Triggers.Discord\Send-PSUDiscordNotification' -EventType JobFailed
```

## Variables

- `$DiscordWebhookUrl`: The URL of the Discord webhook to send messages to. This is required.

## Supported Events

- JobCanceled
- JobFailed
- JobCompleted
- JobStarted
- JobFeedbackRequested
- JobTimedOut