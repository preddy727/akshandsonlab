[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed

### Removed

## [1.2.0] - 2021-06-17

### Added

- added `skip_provider_registration = true` required to skip when deploying to att subscriptions
- added `zones` by default 3 zones
- added `private_ip_ranges` by default set to the 0.0.0.0/0

## [1.0.0] - 2020-11-17

### Changed

- Add networking rg reference to azurefirewall layer [#233715](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/233715)

## [0.11.0] - 2020-11-04

### Added

- KitPath override if kit is stored anywhere other than root in repo
- InputFile tfvars override to allow user defined tfvars file instead of using layername.auto.tfvars

### 2020-11-10

The layer now uses MSI rather than SPN. Your ADO agent pool must have an MSI or the layer will fail, complaining about authentication, missing service principal, etc.
SPN support is DISABLED in this version of the layer. (the variables are commented out and/or removed) If you wish to use SPN, use an earlier version or modify/customize the layer.

## [0.10.0] - 2020-09-18

### Changed

- Resolve Multiple Layer Instance Issue In Layer.sh [#193412](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/193412)

## [0.9.0] - 2020-08-31

### Changed

- Change all layer data lookups to state instead of portal [#175352](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/175352)

## [0.8.0] - 2020-08-25

### Added

- Add Terraform Destroy [144939](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/144939)

## [0.7.0] - 2020-08-25

### Added

- Unable to provide appropriate name for public IP associated with firewall [#170930](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/170930)
