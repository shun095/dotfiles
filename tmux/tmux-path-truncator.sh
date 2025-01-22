#!/bin/bash

cat - | sed "s#^$HOME#~#g" |  sed -e 's@\([^/\]\{2\}\)[^/\]*/@\1/@g' | rev | cut -c 1-40 | rev
