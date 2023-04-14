#!/bin/bash

if [ $# != 0 ]
then
    echo "Error: Invalid number of arguments (should be 0)"
else
    goaccess $(pwd)/../04/log/*.log --log-format=COMBINED -o report.html
    xdg-open report.html
fi