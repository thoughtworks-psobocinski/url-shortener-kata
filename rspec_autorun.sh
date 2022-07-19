#!/bin/bash

trap "echo Exited!; exit;" SIGINT SIGTERM

while true; do
  ag -g '\.rb$' | entr -c -d -p -s "clear; bundle exec rspec ${1:-spec} -fd"
done

# source: https://github.com/nulogy/how_to_code/blob/main/run
