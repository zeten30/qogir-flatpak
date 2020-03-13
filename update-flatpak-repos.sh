#!/bin/bash

FLATPAK_PREFIX=org.gtk.Gtk3theme
THEME_VARIANTS="Qogir::
Qogir::dark
Qogir::light
Qogir::win
Qogir::win-dark
Qogir::win-light
Qogir:manjaro:
Qogir:manjaro:dark
Qogir:manjaro:light
Qogir:manjaro:win
Qogir:manjaro:win-dark
Qogir:manjaro:win-light
Qogir:ubuntu:
Qogir:ubuntu:dark
Qogir:ubuntu:light
Qogir:ubuntu:win
Qogir:ubuntu:win-dark
Qogir:ubuntu:win-light"
REPODIR=./flatpak-repos
GITHUB_PREFIX="git@github.com:flathub/"

rm -rf "${REPODIR}"
mkdir -p "${REPODIR}"

cd "${REPODIR}" || exit 1

# Update all flatpak repos
for th in ${THEME_VARIANTS}; do
  THEME_BASE=$(echo "${th}" | cut -f1 -d ':')
  THEME_FLAVOR=$(echo "${th}" | cut -f2 -d ':')
  THEME_COLOR=$(echo "${th}" | cut -f3 -d ':')
  THEME_ID=$(echo "${THEME_BASE}-${THEME_FLAVOR}-${THEME_COLOR}" | sed -e 's/--/-/g' | sed -s 's/-$//')

  # Clone flatpak repo
  git clone "${GITHUB_PREFIX}${FLATPAK_PREFIX}.${THEME_ID}.git"

  # Copy new files
  cp  "../${FLATPAK_PREFIX}.${THEME_ID}.json" "${FLATPAK_PREFIX}.${THEME_ID}/"
  cp  "../${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}/"

  # Git push
  cd "${FLATPAK_PREFIX}.${THEME_ID}/" || exit 1
  git commit -a -m "Version update"
  git push
  cd ..
done

cd ..