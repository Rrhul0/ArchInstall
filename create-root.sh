#!/bin/bash
echo "testing your internet connection"
if [[ $(ping -w 2 google.com | grep -c transmitted) -eq 1 ]]
then
    echo 'connected to internet'
else
    echo 'not connected to internet'
    echo 'if you have wifi try using "man iwctl"'
fi

