[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Removed
## [3.2.0] - 2021-09-14
- AzureAD provider version missing bugfix
## [3.1.0] - 2021-08-25
- Terraform 1.0 compatible
- Removed layers.sh

## [2.1.0] - 2021-02-10
### Added
- Support in kit(s) for choosing between MSI and SPN via the `useMsi` variable in the kit's Variables.yaml. No change in the layer's function.

## [1.5.0] - 2020-11-05

### Added
- Added support for MSI Object ID to layer, so that the change to use MSI rather than SPN would function properly. (the previously used method to get the principal's object id does not work to find the MSI object's id.)
the new variable is "msi_object_id". This value can be found in the portal by searching for your ADO agent's MSI name in AAD and copying the Object ID from there. 
The command: `az ad sp list --display-name <ADOMSINAME> --output tsv | awk '{print $19}'` should also show it if run from the Azure Cloud Shell, where <ADOMSINAME> is the display name of the MSI.

## [1.4.0] - 2020-11-04


## [1.4.0] - 2020-11-05
### Added
- KitPath override if kit is stored anywhere other than root in repo
- InputFile tfvars override to allow user defined tfvars file instead of using layername.auto.tfvars
- The layer now uses MSI rather than SPN. Your ADO agent pool must have an MSI or the layer will fail, complaining about authentication, missing service principal, etc. 
SPN support is DISABLED in this version of the layer. (the variables are commented out and/or removed) If you wish to use SPN, use an earlier version or modify/customize the layer. 

## [1.4.0] - 2020-11-04

### Added
- KitPath override if kit is stored anywhere other than root in repo
- InputFile tfvars override to allow user defined tfvars file instead of using layername.auto.tfvars

## [1.3.0] - 2020-09-15

### Changed

- Resolve Multiple Layer Instance Issue In Layer.sh [#193412](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/193412)

## [1.2.0] - 2020-08-31

### Changed

- Change all layer data lookups to state instead of portal [#175352](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/175352)

## [1.1.0] - 2020-08-25

### Added

- Add Terraform Destroy [144939](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/144939)

## [1.0.0] - 2020-08-24

### Added

- Initial release of layer tested in POC kit
- Update random_id to use static variable.
