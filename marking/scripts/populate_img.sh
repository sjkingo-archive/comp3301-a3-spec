#!/bin/bash

MNT="/mnt/ext3301"

if [ $# -ne 2 ] ; then
    echo "Usage: $0 image-file fs-type"
    exit 1
fi

function populate_fs {
    m="$MNT"

    touch "$m/test_empty_immediate1" || return 1
    touch "$m/test_empty_immediate2" || return 1

    mkdir "$m/test_empty_dir" || return 2

    mkdir "$m/test_non_empty_dir" || return 3
    mkdir "$m/test_non_empty_dir/test_empty_immediate3" || return 3

    ls -lhR "$m"
}

user="`whoami`"
sudo mount -t "$2" -o loop,debug "$1" "$MNT" && \
sudo chown "$user" "$MNT" && \
populate_fs
r=$?
mount | grep "$2" >/dev/null && sudo umount "$MNT"
exit $r
