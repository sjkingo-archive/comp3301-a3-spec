#!/bin/bash

SIZE="512K"

if [ "$1" = "" ] ; then
    echo "Usage: $0 output-file"
    exit 1
fi

dd if=/dev/zero of="$1" bs="$SIZE" count=0 seek=1 && \
/sbin/mke2fs -F "$1" 2>/dev/null | egrep 'Block size=|inodes,' && \
file "$1"
