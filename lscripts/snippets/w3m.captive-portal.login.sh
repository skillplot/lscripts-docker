#!/bin/bash

# sudo apt install w3m

w3m $(wget -q -O - http://example.com | grep -oP '(?<=window.location=")[^"]*')
