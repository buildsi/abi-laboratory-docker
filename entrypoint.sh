#!/bin/bash

old=$1
new=$2

if [ -z "${old+xxx}" ]; then echo "Missing first argument, old library"; exit 1; fi
if [ -z "${new+xxx}" ]; then echo "Missing second argument, new library"; exit 1; fi

abi-dumper $old -o ABI-1.dump -lver 1
abi-dumper $new -o ABI-2.dump -lver 2
abi-compliance-checker -l NAME -old ABI-1.dump -new ABI-2.dump
