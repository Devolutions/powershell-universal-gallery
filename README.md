# PowerShell Universal Gallery

Public library of modules for PowerShell Universal.

## What is this repository for?

This repository is a collection of modules that you can use directly with PowerShell Universal. These modules provide pre-built solutions for specific platforms like Azure, Windows and Slack. You can download and use this repository as a local resource repository or access these resources from the PowerShell Gallery.

## Support

These modules are not supported through the general Ironman Software support agreement for PowerShell Universal. Bugs and feature requests should be made through this repository. 

## Usage

These resources are published to the PowerShell Gallery. You can install them directly through PowerShell Universal or through PSResourceGet. 

### PowerShell Universal v5

This repository is automatically installed with PowerShell Universal v5 and integrated into the admin console. You can access the gallery by clicking Platform \ Gallery.

![](/images/library.png)

The gallery contains a collection of modules that you can use in your environment. You can install these modules directly from the gallery page. You can also access the gallery from various resource pages.

![](/images/library-button.png)

Solutions installed from the gallery will appear in the Modules page and their resources will automatically be added.

### PowerShell Universal v4

This repository can be installed with PowerShell Universal v4 by registering it as a module repository.
 
#### Add Resources to PSU

You can add resources found in this gallery to your PSU instance by visiting the modules page.  Click Platform \ Modules \ Repositories and select the PSGallery repository.

![](/images/modules.png)

## Contribution guidelines

If you would like to contribute to this repository, please submit a pull request. We accept any PowerShell script that you would like to share with the community. We recommend structure it so that it can be used with PowerShell Universal.

### Structure

Each script should be in a folder that contains the script and a `psd1` file that contains the metadata for the script. To include resources in PowerShell Universal, you can create a `.universal` folder. These will be automatically exposed in PSU when the module is imported. You can view examples within the repository to see how this is accomplished.

Tags, images and description of your module will appear directly in the platform.

### Tags

The following tags are used to categorize modules in PowerShell Universal

- `PowerShellUniversal` - Added to modules that are published to the PowerShell Gallery
- `script` - Contains a script resource
- `app` - Contains an App
- `widget` - Contains one or more Portal Widgets
- `api` - Contains API endpoints
- `trigger` - Contains triggers

### Naming Conventions

We recommend naming your modules so they are discoverable. Consider prefixing with `PowerShellUniversal`, followed by the category of the features, and followed by the specific implementation. 

```
PowerShellUniversal.{Feature}.{Implementation}
```

For example: 

```
PowerShellUniversal.Scripts.ActiveDirectory
PowerShellUniversal.Triggers.Slack
PowerShellUniversal.Widgets.Weather
```

Some modules do not follow this convention, but we recommend it for discoverability.

### Documentation

We prefer that you include comment based help. A `readme.md` is also useful to better describe your module or solution. The readme content will be displayed in PowerShell Universal and the PowerShell Universal Gallery.

### Tests

We currently do not require tests but prefer any tests are written in Pester. We will run these tests during CI builds.

### Publishing to the PowerShell Gallery 

If you have the permissions to publish to the PowerShell Gallery, run the `Publish to PowerShell Gallery` GitHub Action and specify the folder to publish. For example: `ActiveDirectory/PowerShellUniversal.ActiveDirectory.Scripts/`.

