#!/bin/bash

git=`sh /etc/profile; which git`

# Outputs the full branch name of the current branch.
get_full_branch_name() {
  echo `"$git" rev-parse --abbrev-ref HEAD`
}

# Outputs the count of revisions for the given branch
count_revisions() {
  if [ -z "$1" ]; then
    echo "usage: count_revisions <branch name>"
    return 1
  fi

  echo `"$git" rev-list --count $1`
}

# Outputs the short version of the given branch name.
shorten_branch_name() {
  if [ -z "$1" ]; then
    echo "usage: shorten_branch_name <branch name>"
    return 1
  fi

  echo `echo "$1" | awk -F'/' '{print $1}'`
}

# Outputs the branch type (release|develop)
# If the branch name is omitted, the current branch will be used.
get_branch_type() {
  branchName=$1
  if [ -z "$branchName" ]; then
    branchName=`get_full_branch_name`
  fi

  firstToken=`echo "$branchName" | awk -F'-' '{print $1}'`

  if [ "$firstToken" == "release" ]; || [ "$firstToken" == "master" ]; then
    echo "release"
  else
    echo "develop"
  fi
}
