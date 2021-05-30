---
layout: post
title:  "System design"
date:   2021-05-09 05:22:00 +0530
categories: specification
---


## System design

* Whenever sudo is required, it's prompted with the reason
* Log with different log levels are available, by default it's enabled with debug
* Error handing with fail scenarios for missing dependency checks and recommendations
* different level of granularity of system setup
* Docker container compliance through modular configurations and environment variables
* Nvidia stack - driver, cuda, cudnn and tensorrt support for the host and docker containers
* Handpicked and tested for different version dependencies
* Tested on Ubuntu 18.04 LTS

### Core Configuration Modules: `lscripts/config`

**WARNING:**
* DO NOT change the configuration variable names and imports order
* They are sensitive to the order and sequence in which they are defined, hence changing them will have unexpected consequences
* Be Aware and open the script in editor to understand what it is doing, specifically to dangerous function call that can purge or delete things; also better make them internal functions.


The reason for sensitivity towards order and sequence of definitions and imports is because I created a **Cascading Pattern** in order to pass variables & their respective values between different scripts without leaking them in the global scope or to terminal. There is no simple way to use a shell script as a library module, hence the decision is to focus on flexibility over rigidity, simplicity over complexity and modularity of shell scripts. The success of **cascading pattern** to variable passing is due to the unique name space creation mechanism through **consistent naming conventions** and **namespace scoping**.


* uses shell scripts itself for creating configuration variables and files are named as `<configname>-cfg.sh`
* all variables are in local scope, configuration files cannot be used directly and can be used inside functions only
* all variable names are uppercase
* `_color_.sh` => `config/_color_.sh`
  * color codes configurations
* `_typeformats_.sh` => `config/_typeformats_.sh`
  * internal usage for dynamic configurations
* wraps all configurations and it's the single entry point: `__init__.sh` => `config/__init__.sh` like:
  * Core configuration
    * system
    * basepath
    * versions
    * nvidia
    * docker
    * python
  * Users configuration
  * MongoDB configuration
  * Docker container configuration


### Core Utility Modules: `lscripts/utils`

* Logger:`_log_.sh`:
  * `lscripts/utils/_log_.sh`
  * log module
* Utility function modules: `_fn_.sh` => `lscipts/utils/_fn_.sh`
  * `_system_.sh` => `lscripts/utils/_system_.sh`
    * system utility module
  * `_fio_.sh` => `lscripts/utils/_fio_.sh`
    * I/O module
  * `_nvidia_.sh` => `lscripts/utils/_nvidia_.sh`
    * nvidia gpu and cuda stack utility module
  * `_docker_.sh` => `lscripts/utils/_docker_.sh`
    * docker utility module


### Common Module

* Common:`_common_.sh`:
  * high level wrapper
  * wraps the code configurations and core utility functions



### Naming conventions

1. Variable names:
  * namespace
    * `LSCRIPTS`: suggested user defined environment variable namespace
      * use this as prefix for custom environment variables
      * or use this as a variable names withing scripts when using `lscripts` as library module
        * as a convention, use uppercase is they are coming from environment variables, constant values or non-function global variables, otherwise use lowercase for variables in local scope, function names 
    * `_LSCRIPTS__`: Environment variables namespace prefix
    * `<modulename>.<function_name>`: all module functions follow this pattern
  * `_<SOME_NAME>` i.e. starting with single `_` underscore
    * these are reserved variable names
    * function names are tucked under module name eg: `_log_.debug` where module name is `_log_.sh`
  * `__<SOME_NAME>` i.e. starting with double `__` underscores
    * these are reserved variable names
    * strictly private scope, overriding these has unexpected impact
    * function names are tucked under module name.
      * These should not be invoked directly and instead their wrapper function to be used eg: `_log_.__failure` where module name is `_log_.sh` is a expected to private, so instead use it's wrapper: `_log_.fail`
  * Environment variables
    * All environment variables that are expected to be customized by user defined values:
      * namespace prefix: `_LSCRIPTS__`
