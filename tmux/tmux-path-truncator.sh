#!/bin/bash

cat - | sed "s#^$HOME#~#g" |  sed -e 's@\([^/\]\{2\}\)[^/\]*/@\1…/@g'
