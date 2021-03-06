#!/bin/bash

# <https://github.com/flathub/flathub/wiki/App-Submission>

for i in $(ls ../qogir-flatpak/*.json | sed -e 's/.*org/org/' -e 's/\.json//'); do 
  echo ${i}
  git checkout new-pr
  rm -rf *.*
  git checkout -b ${i}
  cp ../qogir-flatpak/${i}.* .
  git add . 
  git commit -a -m "New theme - ${i}"
  git push origin ${i}
done
