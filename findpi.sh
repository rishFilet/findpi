#!/bin/bash
command="`nmap -sP 0.0.0.0/24 255.0.0.0/24`"
while read line
do
  alllines="$line"
  if [[ $line =~ "westworlds" ]]
  then lastline="$line"
  echo "$lastline"
fi
done <<< "$command"
