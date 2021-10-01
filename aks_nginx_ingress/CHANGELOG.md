[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [3.1.0] - 2021-08-25
- Terraform 1.0 compatible
- Removed layers.sh
### Added
  - added cluster_key with default of "aks1" to allow this layer to be used in multi-cluster architectures

### Changed
  - Helm provider version updated to required_version = "~> 2.1.2"
  - updated chart default version to be 3.31.0
  - updated exmaple in var-aks_nginx_ingress.auto.tfvars

### Removed


## [1.4.0] - 2021-05-18
### Changed
- Terraform version updated to required_version = ">= 0.12.31"

## [1.3.0] - 2021-02-10
### Added
- Support in kit(s) for choosing between MSI and SPN via the `useMsi` variable in the kit's Variables.yaml. No change in the layer's function.

## [1.2.0] - 2021-01-05
### Changed
Removed "source" and "load config file" from providers.tf.
Updated Example file.

## [1.1.0] - 2020-12-17
### Changed
Changed variable "version" to "chart_version".

## [1.0.0]
Parameterized/created variables for values in the main.tf, enabling users to specify different values for items including: name, repository, chart, version, replace, create_namespace, and force_update. This provides flexibility in the deployment, as these values can now be specified by the user of the Layer. They are provided with reasonable defaults.  

## [0.4.0] - 2020-11-04

### Added
- KitPath override if kit is stored anywhere other than root in repo
- InputFile tfvars override to allow user defined tfvars file instead of using layername.auto.tfvars
The layer now uses MSI rather than SPN. Your ADO agent pool must have an MSI or the layer will fail, complaining about authentication, missing service principal, etc. 
SPN support is DISABLED in this version of the layer. (the variables are commented out and/or removed) If you wish to use SPN, use an earlier version or modify/customize the layer. 

### Added
Added the layer.
### Changed

### Removed

## 2020-09-24
### Added
Added backend "azurerm" {} to Providers.
### Removed
Removed references to create_namespace (not needed) and removed test entries for replace and force_update. 
