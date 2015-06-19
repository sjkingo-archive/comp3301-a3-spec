#!/bin/bash

i="$1"
o="$i/a3.patch"
diff -w -B -E -r -X exclude ~/linux-2.6.32.21/fs/ext2 $i >$o
echo "Wrote diff (`wc -l $o | awk '{print $1}'` lines) to $o"
