#!/bin/sh

BIN=$(which ghc-pkg)
PKGDB=/root/.stack/snapshots/x86_64-linux/lts-11.17/8.2.2/pkgdb
PKGS=$($BIN --package-db $PKGDB list --simple-output)

for iters in $(seq 100); do
    count=0
    for pkg in $PKGS; do
        # echo $pkg
        $BIN --package-db $PKGDB describe $pkg | $BIN --global register - > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            count=$(expr $count + 1)
        else
            echo $pkg >> /tmp/toadd
        fi
    done
    echo "Added $count packages into GHC global pkg db!"
    PKGS=$(cat /tmp/toadd)
    if [ $(cat /tmp/toadd | wc -l) -eq 0 ]; then
        exit 0
    fi
    rm /tmp/toadd && touch /tmp/toadd
    if [ $count -eq 0 ]; then
       exit 1
    fi
done

$BIN --global list
