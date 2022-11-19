#!/bin/bash

sudo apt -y install mlocate
sudo updatedb && locate -e bench-repo
ls -l $(locate -e bench-repo)

# https://www.folkstalk.com/2022/09/locate-can-not-stat-var-lib-mlocate-mlocate-db-no-such-file-or-directory-with-code-examples.html
# The binary database used by locate (/var/lib/mlocate/mlocate.db) is updated once daily by cron, so locate will not find new files.

# 1. You can fix this by first running sudo updatedb
# sudo updatedb && locate -e bench-repo

# 2. It's a good idea to use the -e flag so you only find files that still exist.

# 3. Oh and here's a bonus tip - you can get locate to give you a detailed listing  by passing to ls -l

# ls -l $(locate -e bench-repo)
