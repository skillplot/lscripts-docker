---
title: [Legacy] Dht11 Humidity Sensor
date: "2022-09-18 09:00:00 +0530"
categories:
  - Archive
  - Lscripts-docker
tags:
  - IoT
  - Raspberry Pi
  - legacy
  - lscripts-docker
toc: true
---
{: .prompt-warning }
This is an **archived** post migrated from the previous minima-based site. It may describe older workflows or legacy setups.

## Dht11 Humidity Sensor

1. Install libgpiod2
    ```bash
    sudo apt install libgpiod2
    ```
2. Python dependencies
  ```bash
  pip install psutil
  pip install adafruit-python-shell
  pip install adafruit-circuitpython-dht
  ```

## Reference

* [DHT11/DHT22 Humidity Sensor](https://learn.adafruit.com/dht/dht-circuitpython-code)
