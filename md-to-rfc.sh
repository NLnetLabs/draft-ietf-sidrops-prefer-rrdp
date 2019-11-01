#!/bin/bash

if [ -z ${1+x} ]; then
  echo "Usage: $0 [base-file-name-without-dot-md]"
  exit
fi

BASE=$1

mmark -xml2 -page $BASE.md  > $BASE.xml && xml2rfc --text --html $BASE.xml
