#!/bin/bash

num_of_screens=$(./xrdr.sh print)


if [ $num_of_screens -eq 1 ]
then
  echo "2* | 1" | ./xrdr.sh layout
  nitrogen --restore
fi

