#!/bin/bash

echo $-

if [[ $- == *i* ]]
then
    echo YES
fi
