#!/bin/bash

FLATPAK_PREFIX=org.gtk.Gtk3theme
RELEASE_TAR=2019-08-31.tar.gz
RELEASE_SHA256=e2c26c29d8a72bc67bcd13934cc1ef95587295a5dbc50dd61f047891a75e3b4d
BRANCH=3.22
RUNTIME_V=3.26
THEME_VARIANTS="Qogir
Qogir-dark
Qogir-light
Qogir-manjaro
Qogir-manjaro-dark
Qogir-manjaro-light
Qogir-manjaro-win
Qogir-manjaro-win-dark
Qogir-manjaro-win-light
Qogir-ubuntu
Qogir-ubuntu-dark
Qogir-ubuntu-light
Qogir-ubuntu-win
Qogir-ubuntu-win-dark
Qogir-ubuntu-win-light
Qogir-win
Qogir-win-dark
Qogir-win-light"



for th in ${THEME_VARIANTS}; do
  # Copy templates
  cp templates/appdata.template.xml "${FLATPAK_PREFIX}.${th}.appdata.xml"
  cp templates/manifest.template.json "${FLATPAK_PREFIX}.${th}.json"

  # Replace strings
  sed -i "s/{{theme}}/${th}/g" "${FLATPAK_PREFIX}.${th}.appdata.xml" "${FLATPAK_PREFIX}.${th}.json"
  sed -i "s/{{prefix}}/${FLATPAK_PREFIX}/g" "${FLATPAK_PREFIX}.${th}.appdata.xml" "${FLATPAK_PREFIX}.${th}.json"
  sed -i "s/{{release_tar}}/${RELEASE_TAR}/g" "${FLATPAK_PREFIX}.${th}.appdata.xml" "${FLATPAK_PREFIX}.${th}.json"
  sed -i "s/{{release_sha256}}/${RELEASE_SHA256}/g" "${FLATPAK_PREFIX}.${th}.appdata.xml" "${FLATPAK_PREFIX}.${th}.json"
  sed -i "s/{{branch}}/${BRANCH}/g" "${FLATPAK_PREFIX}.${th}.appdata.xml" "${FLATPAK_PREFIX}.${th}.json"
  sed -i "s/{{runtime_v}}/${RUNTIME_V}/g" "${FLATPAK_PREFIX}.${th}.appdata.xml" "${FLATPAK_PREFIX}.${th}.json"

  # Build in local-repo
  flatpak-builder --repo=local-repo --force-clean build "${FLATPAK_PREFIX}.${th}.json"
done

# Show local-repo installation
echo ""
echo "## Installation ##"
echo "flatpak --user remote-add --no-gpg-verify local-repo local-repo"

for th in ${THEME_VARIANTS}; do
  # Show local install
  echo "flatpak --user install local-repo ${FLATPAK_PREFIX}.${th} -y"
done