#! /bin/bash
convert ../references/$1 -filter point -resize 171%x200% -page +04-12 -background none -flatten $1

