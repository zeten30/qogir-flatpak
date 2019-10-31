#!/bin/bash

FLATPAK_PREFIX=org.gtk.Gtk3theme
RELEASE_TAR=2019-10-25.tar.gz
RELEASE_SHA256=07027ad930f4cba10c92ce782fa6b3747afefaafc4bc029692e95ad8f3dcd1ff
BRANCH=3.22
RUNTIME_V=3.26
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
MANIFESTS_TO_BUILD=""
LOCAL_REPO=qogir-flatpak-local-repo

for th in ${THEME_VARIANTS}; do
  THEME_BASE=$(echo "${th}" | cut -f1 -d ':')
  THEME_FLAVOR=$(echo "${th}" | cut -f2 -d ':')
  THEME_COLOR=$(echo "${th}" | cut -f3 -d ':')
  THEME_ID=$(echo "${THEME_BASE}-${THEME_FLAVOR}-${THEME_COLOR}" | sed -e 's/--/-/g' | sed -s 's/-$//')
  THEME_FLAVOR_ESCAPED=$(echo "${THEME_FLAVOR}" | sed -e 's/^/-/' | sed -e 's/-$//')
  THEME_COLOR_ESCAPED=$(echo "${THEME_COLOR}" | sed -e 's/^/-/' | sed -e 's/-$//')
  THEME_FULL_DARK=$(echo "${THEME_COLOR}" | grep -c 'dark')
  THEME_ALTER_COLOR_ESCAPED="${THEME_COLOR_ESCAPED/light/dark}"

  if [ "${THEME_ALTER_COLOR_ESCAPED}" == "" ]; then
    THEME_ALTER_COLOR_ESCAPED="-dark"
  fi

  # Copy templates
  cp templates/appdata.template.xml "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml"
  cp templates/manifest.template.json "${FLATPAK_PREFIX}.${THEME_ID}.json"

  # Replace strings
  sed -i "s/{{theme}}/${THEME_ID}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"
  sed -i "s/{{flavor}}/${THEME_FLAVOR_ESCAPED}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"
  sed -i "s/{{color}}/${THEME_COLOR_ESCAPED}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json" 
  sed -i "s/{{prefix}}/${FLATPAK_PREFIX}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"
  sed -i "s/{{release_tar}}/${RELEASE_TAR}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"
  sed -i "s/{{release_sha256}}/${RELEASE_SHA256}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"
  sed -i "s/{{branch}}/${BRANCH}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"
  sed -i "s/{{runtime_v}}/${RUNTIME_V}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"

  if [ "${THEME_FULL_DARK}" == "0" ]; then
    sed -i "s/{{alter_color}}/${THEME_ALTER_COLOR_ESCAPED}/g" "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"
  else
    sed -i '/{{alter_color}}/d' "${FLATPAK_PREFIX}.${THEME_ID}.appdata.xml" "${FLATPAK_PREFIX}.${THEME_ID}.json"
  fi

  MANIFESTS_TO_BUILD="${MANIFESTS_TO_BUILD}${FLATPAK_PREFIX}.${THEME_ID}.json
  "
done

# Install ??
if [ "${1}" == "install" ]; then
  mkdir -p "${LOCAL_REPO}"
  flatpak --user remote-delete "${LOCAL_REPO}"

  for f in ${MANIFESTS_TO_BUILD}; do
    flatpak-builder --repo="${LOCAL_REPO}" --force-clean build "${f}"
  done

  flatpak --user remote-add --no-gpg-verify "${LOCAL_REPO}" "${LOCAL_REPO}"

  for f in ${MANIFESTS_TO_BUILD}; do
    flatpak --user install "${LOCAL_REPO}" "${f/.json//}" -y
  done

fi