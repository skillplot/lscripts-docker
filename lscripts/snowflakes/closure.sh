#!/bin/bash
(
  ## http://tldp.org/LDP/abs/html/subshells.html
  ## http://tldp.org/LDP/abs/html/timedate.html#BATCHPROCREF
  ## Inside parentheses, and therefore a subshell . . .
  msg="World"
  function greetings() {
    echo "Hello ${msg}"
  }

  greetings
) 1>&2

## these are not accessible even after sourcing the script
# echo ${msg}
# greetings
