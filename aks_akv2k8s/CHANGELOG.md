[[_TOC_]]

# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Changed
Changed to use the merged helm chart akv2k8s 1.2.X also known as helm chart version 2.0.X

## [1.3.0] - 2021-05-18
### Changed
- Terraform version updated to required_version = ">= 0.12.31"

## [1.2.0] - 2021-02-10
### Added
- Support in kit(s) for choosing between MSI and SPN via the `useMsi` variable in the kit's Variables.yaml. No change in the layer's function.

## [1.1.0] - 2021-01-05
### Changed
Removed "source" and "load config file" from providers.tf.
Updated Example file.

## [1.0.0] - 2020-12-16

### Changed
Fully parameterized the variables used. Updated the example auto.tfvars file. 
Created variables for values in the main.tf, enabling users to specify different values for items including: name, repository, chart, version, replace, create_namespace, and force_update. This provides flexibility in the deployment, as these values can now be specified by the user of the Layer. They are provided with reasonable defaults.  

### Added
Added a variable for the deploy timeout value (defaults to 300)

## [0.5.0] - 2020-11-04

### Added
- KitPath override if kit is stored anywhere other than root in repo
- InputFile tfvars override to allow user defined tfvars file instead of using layername.auto.tfvars
The layer now uses MSI rather than SPN. Your ADO agent pool must have an MSI or the layer will fail, complaining about authentication, missing service principal, etc. 
SPN support is DISABLED in this version of the layer. (the variables are commented out and/or removed) If you wish to use SPN, use an earlier version or modify/customize the layer. 

## 2020-10-01
### Changed
Modified main.tf and variables.tf to fix installation.

## 2020-09-24
### Added
Added backend "azurerm" {} to Providers.
### Changed
Changed namespace to "default".
### Removed
Removed references to create_namespace (not needed) and removed test entries for replace and force_update. 