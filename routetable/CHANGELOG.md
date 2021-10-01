[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.8.0] - 2021-7-14

- fixed issue with the statefile

## [0.6.0] - 2021-7-14

- fixed bug in azure_firewall_name lookup

## [0.5.0] - 2021-1-7

- Added feature of adding route table to multiple subnets[#361854](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/361854)

## [0.4.0] - 2020-11-20

### Added

### Changed

- Modified next hop in ip address condition[#244322](https://dev.azure.com/ATTDevOps/06a79111-55ca-40be-b4ff-0982bd47e87c/_workitems/edit/244322)

### Removed

## [Unreleased]

### Changed

## [0.2.0] - 2020-11-04

### Added

- KitPath override if kit is stored anywhere other than root in repo
- InputFile tfvars override to allow user defined tfvars file instead of using layername.auto.tfvars

## 2020-11-10

The layer now uses MSI rather than SPN. Your ADO agent pool must have an MSI or the layer will fail, complaining about authentication, missing service principal, etc.
SPN support is DISABLED in this version of the layer. (the variables are commented out and/or removed) If you wish to use SPN, use an earlier version or modify/customize the layer.

## [0.1.0] - 2020-08-31

### Changed

- Change all layer data lookups to state instead of portal [#175352](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/175352)
