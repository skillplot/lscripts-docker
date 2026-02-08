---
title: System design
date: "2021-05-09 09:00:00 +0530"
categories:
  - System design
tags:
  - lscripts-docker
  - specification
toc: true
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


* Uses shell scripts itself for creating configuration variables and files are named as `<configname>-cfg.sh`
* All variables are in local scope, configuration files cannot be used directly and can be used inside functions only
* All variable names are uppercase
* Color codes configurations
  * `_color_.sh` => `config/_color_.sh`
* Internal usage for dynamic configurations
  * `_typeformats_.sh` => `config/_typeformats_.sh`
* Wraps all configurations and it's the single entry point: `__init__.sh` => `config/__init__.sh` like:
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


### Core Modules: `lscripts/core`

All the Code modules are loaded from: => `lscipts/core/__init__.sh`. Here they are mentioned in the same order in which they are imported, their import orders should not be changed. There are two types of modules:
1. wrapper modules - they only prints configuration currently
2. functional modules - they additionally adds more functionalities


* log
  * log module
    * `lscripts/core/_log_.sh`
* utils module
  * `_utils_.sh` => `lscripts/core/_utils_.sh`
* date module
  * `_date_.sh` => `lscripts/core/_date_.sh`
* color wrapper module
  * `_color_.sh` => `lscripts/core/_color_.sh`
* typeformats wrapper module
  * `_typeformats_.sh` => `lscripts/core/_typeformats_.sh`
* system module
  * `_system_.sh` => `lscripts/core/_system_.sh`
* file I/O module
 * `_fio_.sh` => `lscripts/core/_fio_.sh`
* Stack wrapper module
 * `_stack_.sh` => `lscripts/core/_stack_.sh`
* dir module
  * `_dir_.sh` => `lscripts/core/_dir_.sh`
* apt module
  * `_apt_.sh` => `lscripts/core/_apt_.sh`
* nvidia gpu and cuda stack module
  * `_nvidia_.sh` => `lscripts/core/_nvidia_.sh`
* docker module
  * `_docker_.sh` => `lscripts/core/_docker_.sh`
* mongodb wrapper module
  * `_mongodb_.sh` => `lscripts/core/_mongodb_.sh`


### Common Module

* Common:`_common_.sh`:
  * high level wrapper
  * wraps the code configurations and core functions



### Naming conventions

1. Variable names:
  * namespace
    * `LSCRIPTS`: suggested user defined environment variable namespace
      * use this as prefix for custom environment variables
      * or use this as a variable names withing scripts when using `lscripts` as library module
        * as a convention, use uppercase is they are coming from environment variables, constant values or non-function global variables, otherwise use lowercase for variables in local scope, function names 
    * `LSCRIPTS__`: Environment variables namespace prefix
    * `<modulename>.<function_name>`: all module functions follow this pattern
  * `_<SOME_NAME>` i.e. starting with single `_` underscore
    * these are reserved variable names
    * function names are tucked under module name eg: `lsd-mod.log.debug` where module name is `_log_.sh`
  * `__<SOME_NAME>` i.e. starting with double `__` underscores
    * these are reserved variable names
    * strictly private scope, overriding these has unexpected impact
    * function names are tucked under module name.
      * These should not be invoked directly and instead their wrapper function to be used eg: `lsd-mod.log.__failure` where module name is `_log_.sh` is a expected to private, so instead use it's wrapper: `lsd-mod.log.fail`
  * Environment variables
    * All environment variables that are expected to be customized by user defined values:
      * namespace prefix: `LSCRIPTS__`
