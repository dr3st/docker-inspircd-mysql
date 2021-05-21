#!/usr/bin/env bash

INSP_VERSION="${1:-v3.10.0}"
IMAGE_TAG="inspircd:${INSP_VERSION}"
GIT_URL="https://github.com/inspircd/inspircd-docker.git"

# check if git is installed (needed to checkout inspircd-docker)
(which git > /dev/null 2>&1) || (echo "not installed"; exit 1)

# create temp directory to checkout inspircd-docker inside
temp_dir=$(mktemp -d)

cd "${temp_dir}"
git clone "${GIT_URL}" inspircd-docker
cd "${temp_dir}/inspircd-docker"

docker build . \
	-t ${IMAGE_TAG} \
	--build-arg VERSION=${INSP_VERSION} \
	--build-arg CONFIGUREARGS="--enable-extras mysql --enable-extras regex_pcre" \
	--build-arg BUILD_DEPENDENCIES="mariadb-dev pcre-dev" \
	--build-arg RUN_DEPENDENCIES="mariadb-connector-c"

# remove local git repository
rm -Rf "${temp_dir}"

