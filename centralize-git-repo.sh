#!/bin/bash
###
### Takes the name of a git repo and a remote git server
### Copies a bare version of the repo to the server, and adds it as
### remote to the loca git repo
###
### e.g.: centralize-git-repo.sh localrepo user@gitserver:/srv/git
### Generates folder in server:/git/localrepo.git
### and a git remote in local repo
###
set -e

GIT="/usr/bin/git"
SCP="/usr/bin/scp"

if [ "$1" == "--help" ] || [ $# -eq 0 ] ; then
    echo "$0 [repo] [user@]hostname:[remote_git_path]"
    exit 0
fi

# Assign parameters
LOCAL_REPO=$(basename $1)
REMOTE_DIR=$2

# Checks if the repo exists in current directory.
if [ ! -d "${LOCAL_REPO}" ]; then
    echo "${LOCAL_REPO} is not a repo in current directory."
    exit 1
fi

# Checks second parameter is present
if [ ! "${REMOTE_DIR}" ]; then
    echo "Remote is missing, pass the target dir on the remote "
    echo " server as the second parameter as: user@server:/dir/../git/"
    echo ""
    echo "e.g.: $0 localrepo user@gitserver:/srv/git"
    exit 1
fi

######

# Creates a container for the bare repo
BARE_TMP_DIR=$(mktemp --quiet --directory)
NEW_REPO_DIRNAME=${LOCAL_REPO}.git
BARE_REPO_PATH=${BARE_TMP_DIR}/${NEW_REPO_DIRNAME}

mkdir ${BARE_REPO_PATH}

$GIT clone --bare ${LOCAL_REPO} ${BARE_REPO_PATH}/

$SCP -r ${BARE_REPO_PATH} ${REMOTE_DIR}

# add remote
cd ${LOCAL_REPO}
$GIT remote add origin ${REMOTE_DIR}/${NEW_REPO_DIRNAME}
$GIT remote -v

# clean
rm -rf ${BARE_TMP_DIR}
cd ..

echo "Success!"
