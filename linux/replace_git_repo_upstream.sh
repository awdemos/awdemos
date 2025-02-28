#!/bin/sh

set -eux -o pipefail

export GIT_USER=<username>
export GIT_REPO_NAME=<repo_name>  # What the user is going to call the repo

mkdir -p ~/workspace/${GIT_USER}/${GIT_REPO_NAME}
cd ~/workspace/${GIT_USER}/${GIT_REPO_NAME}

# Make git repo
git init .

# git-remote-ify the upstream repo
git remote add upstream git@github.com:<upstream_org>/${GIT_REPO_NAME}.git
git remote -v

# origin	git@github.com:${GIT_USER}/${GIT_REPO_NAME}.git (fetch)
# origin	git@github.com:${GIT_USER}/${GIT_REPO_NAME}.git (push)
# upstream	git@github.com:<upstream_org>/${GIT_REPO_NAME}.git (fetch)
# upstream	git@github.com:<upstream_org>/${GIT_REPO_NAME}.git (push)

# Pull repo from upstream
git pull upstream main --allow-unrelated-histories

git branch -M main
git remote add origin git@github.com:${GIT_USER}/${GIT_REPO_NAME}.git
git push -u origin main

git push --set-upstream origin main

