#!/bin/bash
# Maintenance process automation script. 
# Used to create new che-theia and machine-exec plugins and commit changes more easily.

NOCOMMIT=0
BRANCH="crw-2.5-rhel-8"

while [[ "$#" -gt 0 ]]; do
  case $1 in
    '-n'|'--no-commit') NOCOMMIT=1; shift 0;;
    '-b') BRANCH="$2"; shift 1;;
    *) VERSION="$1"; shift 0;;
  esac
  shift 1
done

usage ()
{
  echo "Usage:   $0 [VERSION TO ADD] [--no-commit]"
  echo "Example: $0 7.17.0 -b crw-2.5-rhel-8"; echo
}

if [[ ! ${VERSION} ]]; then
  usage
  exit 1
fi

# generate new meta.yaml files for the plugins, and update the latest.txt files
createNewPlugins () {
  newVERSION=$1
  rsync -aqrz v3/plugins/eclipse/che-machine-exec-plugin/nightly/* "v3/plugins/eclipse/che-machine-exec-plugin/${newVERSION}/"
  rsync -aqrz v3/plugins/eclipse/che-theia/next/* "v3/plugins/eclipse/che-theia/${newVERSION}/"
  pwd
  for m in "v3/plugins/eclipse/che-theia/${newVERSION}/meta.yaml" "v3/plugins/eclipse/che-machine-exec-plugin/${newVERSION}/meta.yaml"; do
    sed -i "${m}" \
        -e "s#firstPublicationDate:.\+#firstPublicationDate: \"$(date +%Y-%m-%d)\"#" \
        -e "s#version: \(nightly\|next\)#version: ${newVERSION}#" \
        -e "s#image: \"\(.\+\):\(nightly\|next\)\"#image: \"\1:${newVERSION}\"#" \
        -e "s# development version\.##" \
        -e "s#, get the latest release each day\.##"
  done
  for m in v3/plugins/eclipse/che-theia/latest.txt v3/plugins/eclipse/che-machine-exec-plugin/latest.txt; do
    echo "${newVERSION}" > $m
  done
}

removeOldPlugins () {
  newVERSION=$1
  for d in $(find v3/plugins/eclipse/che-machine-exec-plugin v3/plugins/eclipse/che-theia -maxdepth 1 -mindepth 1 -type d); do
    if [[ $d != *"next" ]] && [[ $d != *"nightly" ]] && [[ $d != *"$newVERSION" ]]; then
      # echo "Remove old plugin dir $d"
      git rm -fr $d || true
      rm -fr $d || true
    fi
  done
}

# check if che-machine-exec-plugin and che-theia version is already installed to avoid redundent commits
if [[ ! -d "v3/plugins/eclipse/che-machine-exec-plugin" ]] || \
   [[ ! -d "v3/plugins/eclipse/che-machine-exec-plugin/${VERSION}/" ]] || \
   [[ ! -f "v3/plugins/eclipse/che-machine-exec-plugin/${VERSION}/meta.yaml" ]] || \
  [[ $(cat "v3/plugins/eclipse/che-machine-exec-plugin/latest.txt") != "${VERSION}" ]] || \
   [[ ! -d "v3/plugins/eclipse/che-theia" ]] || \
   [[ ! -d "v3/plugins/eclipse/che-theia/${VERSION}/" ]] || \
   [[ ! -f "v3/plugins/eclipse/che-theia/${VERSION}/meta.yaml" ]] || \
  [[ $(cat "v3/plugins/eclipse/che-theia/latest.txt") != "${VERSION}" ]]; then
  # change VERSION file
  echo "${VERSION}" > VERSION
  # remove old che-machine-exec and che-theia plugins, keeping only nightly, next, and ${VERSION}
  removeOldPlugins "${VERSION}"
  # add new plugins + update latest.txt files
  createNewPlugins "${VERSION}"

  # commit change into branch
  if [[ ${NOCOMMIT} -eq 0 ]]; then
    COMMIT_MSG="[release] Add che-theia and che-machine-exec plugins ${VERSION} in ${BRANCH}"
    git add v3/plugins/eclipse/ || true
    git commit -s -m "${COMMIT_MSG}" VERSION v3/plugins/eclipse/
    git pull origin "${BRANCH}"
    git push origin "${BRANCH}"
  fi
else
    echo "[WARNING] che-theia and che-machine-exec plugins ${VERSION} already in registry - nothing to do."
fi
