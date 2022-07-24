#!/bin/bash

old=$1
new=$2u

if [ -z "${old+xxx}" ]; then echo "Missing first argument, old library"; exit 1; fi
if [ -z "${new+xxx}" ]; then echo "Missing second argument, new library"; exit 1; fi

dump_old=$(mktemp /tmp/ABI-1-XXXXX.dump)
dump_new=$(mktemp /tmp/ABI-2-XXXXX.dump)

abi-dumper $old -o $dump_old -lver 1
abi-dumper $new -o $dump_new -lver 2
abi-compliance-checker -l NAME -old $dump_old -new $dump_new
rm $dump_old
rm $dump_new
