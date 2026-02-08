---
title: Color Codes
date: "2021-06-13 09:00:00 +0530"
categories:
  - Color Codes
tags:
  - color-codes
  - lscripts-docker
toc: true
---

## Overview



* Color code `variables` for `lscripts` configuration variables can be known and visualized as:
    ```bash
    lsd-cfg.color
    ```
![ALT lsd configuration colors]({{ "/images" | relative_url }}/lsd-cfg.color.png)


## Logger Color Codes


* The log module is: `${LSCRIPTS_DOCKER}/lscripts/core/lsd-mod.log.sh` 
* Total `8` color codes are there one for each log levels.
* In the give image there are illustration for `6` color codes for respective log levels. There're two additional for `stacktrace` and `fail` log levels.
![ALT lsd configuration colors]({{ "/images" | relative_url }}/lsd-test.lsd-mod.log.png)
* All the color codes for can be visualized from running the logger module test as:
    ```bash
    lsd-test.log
    ```
