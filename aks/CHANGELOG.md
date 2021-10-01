[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.1.0] - 2021-08-25
- Terraform 1.0 compatible
- Removed layers.sh

## [2.4.0] - 2021-05-18
### Added
- Support for node_taints and node_labels on the AKS cluster default node pool and additional node pools. Note that for the default pool the only taint allowed is ["CriticalAddonsOnly=true:NoSchedule"] Additional information can be found here: https://docs.microsoft.com/en-us/azure/aks/use-system-pools#system-and-user-node-pools

## [2.3.0] - 2021-04-28
### Changed
- Default for kube dashboard set to false, in order to work with AKS versions that no longer support the dashboard.  

## [2.1.0] - 2021-02-10
### Added
- Support in kit(s) for choosing between MSI and SPN via the `useMsi` variable in the kit's Variables.yaml. No change in the layer's function.

## [2.0.0] - 2020-11-17

### Changed

- Add networking rg reference to aks layer [#233717](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/233717)

## [0.10.0] - 2020-11-04

### Added

- KitPath override if kit is stored anywhere other than root in repo
- InputFile tfvars override to allow user defined tfvars file instead of using layername.auto.tfvars

## 2020-11-10

The layer now uses MSI rather than SPN. Your ADO agent pool must have an MSI or the layer will fail, complaining about authentication, missing service principal, etc.
SPN support is DISABLED in this version of the layer. (the variables are commented out and/or removed) If you wish to use SPN, use an earlier version or modify/customize the layer.

## [0.9.0] - 2020-09-25

### Changed

Fixed: removed requirement for SPN client id and secret when it should not be required (when using managed aad rbac) https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/199466

## [0.5.0] - 2020-09-18

### Changed

- Resolve Multiple Layer Instance Issue In Layer.sh [#193412](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/193412)

## [0.4.0] - 2020-09-03

### Changed

- Support AKS-managed Azure Active Directory integration [#178241](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/178241)

## [0.3.0] - 2020-08-31

### Changed

- Change all layer data lookups to state instead of portal [#175352](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/175352)

## [0.2.0] - 2020-08-25

### Added

- Add Terraform Destroy [144939](https://dev.azure.com/ATTDevOps/ATT%20Cloud/_workitems/edit/144939)
