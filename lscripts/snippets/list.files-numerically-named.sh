find . -type f -name '*.jpg' -print0 | xargs -0 -n 1 basename | sort -V > list.txt