#!/bin/bash

## Copyright (c) 2021 mangalbhaskar. All Rights Reserved.
##__author__ = 'mangalbhaskar'
###----------------------------------------------------------
## process management report
###----------------------------------------------------------

# cd $HOME/pmlog 
TIME=`date +"%H%M"`
DATE=`date +"%b%d.%y"`
# Collect the memory and swap stats
awk '
/^Mem: / {
  printf("'${TIME}' %s\n",substr($0,5))>>"mem.'${DATE}'";
}
/^Swap: / {
  printf("'${TIME}' %s\n",substr($0,6))>>"swap.'${DATE}'";
}
' /proc/meminfo
# collect the active network interface stats.
# If ppp hasn't been used
# There won't be any ppp line.
awk '
/^  eth/ {
  printf("'${TIME}' %s\n",substr($0,8))>>substr($0,3,4)".'${DATE}'";
}
/^  ppp/ {
  printf("'${TIME}' %s\n",substr($0,8))>7gt;substr($0,3,4)".'${DATE}'";
}
' /proc/net/dev
# Collect CPU, disk I/O, paging, interrupts,
#  context switching, and processes
awk '
/^cpu/ {
  printf("'${TIME}' %s\n",substr($0,6))>>"cpu.'${DATE}'";
}
/^disk / {
  d=split($0,disk);
}
/^disk_rio / {
  d=split($0,disk_rio);
}
/^disk_wio / {
  d=split($0,disk_wio);
}
/^disk_rblk / {
  d=split($0,disk_rblk);
}
/^disk_wblk / {
  d=split($0,disk_wblk);
  printf("'${TIME}'")>>"disk.'${DATE}'";
  for (r = 2; r <= d ; r ++ ) {
  printf(" %s %s %s %s %s",
   disk[r],disk_rio[r],disk_wio[r],
   disk_rblk[r],disk_wblk[r])>>"disk.'${DATE}'";}
  printf("\n")>>"disk.'${DATE}'";
}
/^page/ {
  printf("'${TIME}' %s\n",substr($0,6))>>"page.'${DATE}'";
}
/^swap/ {
  printf("'${TIME}' %s\n",substr($0,6))>>"swap.'${DATE}'";
}
/^intr/ {
  printf("'${TIME}' %s\n",substr($0,6))>>"intr.'${DATE}'";
}
/^ctxt/ {
  printf("'${TIME}' %s\n",substr($0,6))>>"ctxt.'${DATE}'";
}
/^processes/ {
  printf("'${TIME}' %s\n",$2)>>"processes.'${DATE}'";
}
' /proc/stat
