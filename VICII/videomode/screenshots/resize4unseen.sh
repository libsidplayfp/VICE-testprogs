#! /bin/bash
convert ../references/$1 -filter point -resize 179%x200% -page -04-15 -background none -flatten $1

