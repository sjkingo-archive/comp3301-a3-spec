#!/bin/bash

if [ -z "$1" ] ; then
    echo "Usage: $0 student-dir"
    exit 1
fi

D="$1"

BF="$D/build_output.txt"
PF="$D/a3.patch"
IMG="$D/ext3301.img"

function die {
    echo "Error: $1" >>$BF
    exit 3
}

echo "Building solution for `basename $D`" >$BF

# diff the changes
diff -BEuwr -X exclude ~/linux-2.6.32.21/fs/ext2 $D >>$PF
echo "Generated diff against ext2 (`wc -l $PF | awk '{print $1}'` lines)" >>$BF
echo >>$BF

# build module - this should produce only 1 .ko
pushd $D 2>/dev/null
make >>$BF 2>&1
if [ $? -ne 0 ] ; then
    popd 2>/dev/null
    die "building module failed"
fi
echo "Module(s) found:" >>$BF
echo -n "  " >>$BF
ls -l *.ko >>$BF
popd 2>/dev/null

# create a new image file with ext2 inside
./create_img.sh $IMG 2>&1 >>$BF || die "failed to create image"

# load the module so we can mount as ext3301

# populate the ext3301 image
#./populate_img.sh $IMG ext3301

echo "Finished builing solution. Ready to test." >>$BF

exit 0
