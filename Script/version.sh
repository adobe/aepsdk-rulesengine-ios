#!/usr/bin/env bash

set -e

if which jq >/dev/null; then
    echo "jq is installed"
else
    echo "error: jq not installed.(brew install jq)"
fi

NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'

#  ---- enable the following code after the new pod has been released. ----
# LATEST_PUBLIC_VERSION=$(pod spec cat AEPRulesEngine | jq '.version' | tr -d '"')
# echo "Latest public version is: ${BLUE}$LATEST_PUBLIC_VERSION${NC}"
# if [[ "$1" == "$LATEST_PUBLIC_VERSION" ]]; then
#     echo "${RED}[Error]${NC} $LATEST_PUBLIC_VERSION has been released!"
#     exit -1
# fi

echo "Start to check the version in podspec file >"
echo "Target version - ${BLUE}$1${NC}"
# PODSPEC_VERSION=$(cat ./SwiftRulesEngineTest.podspec | egrep '^\s*s.version\s*=\s*\"(.*)\"' | ruby -e "puts gets.scan(/^\s*s.version\s*=\s*\"(.*)\"/)[0] ")
PODSPEC_VERSION=$(pod ipc spec AEPRulesEngine.podspec | jq '.version' | tr -d '"')
echo "Local podspec version - ${BLUE}${PODSPEC_VERSION}${NC}"
if [[ "$1" == "$PODSPEC_VERSION" ]]; then
    echo "${GREEN}Pass!"
    exit 0
else
    echo "${RED}[Error]${NC} Version do not match!"
    exit -1
fi
