#!/bin/bash

old=$1
new=$2
name=${3:-NAME}

if [ -z "${old+xxx}" ]; then echo "Missing first argument, old library"; exit 1; fi
if [ -z "${new+xxx}" ]; then echo "Missing second argument, new library"; exit 1; fi

dump_old=$(mktemp /tmp/ABI-1-XXXXX.dump)
dump_new=$(mktemp /tmp/ABI-2-XXXXX.dump)
report_path=$(mktemp /tmp/report-XXXXX.html)

# Options: https://github.com/lvc/abi-dumper/blob/master/abi-dumper.pl#L112
abi-dumper $old -o $dump_old -lver 1
abi-dumper $new -o $dump_new -lver 2

# Options: https://github.com/lvc/abi-compliance-checker/blob/master/abi-compliance-checker.pl#L119
abi-compliance-checker -l $name -old $dump_old -new $dump_new -report-path $report_path
rm $dump_old
rm $dump_new
rm $report_path
