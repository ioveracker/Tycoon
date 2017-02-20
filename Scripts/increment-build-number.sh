# Set the build number based on the current branch and commit count.
# If this is a release branch build, only the commit count is used,
# otherwise the branch name and commit count are used. This is to make
# collisions across feature branches less likely.
# Based on: http://blog.jaredsinclair.com/post/97193356620/the-best-of-all-possible-xcode-automated-build
git_utils=`find . -name git-utils.sh`
source $git_utils
fullBranchName=`get_full_branch_name`
appBuild=`count_revisions $fullBranchName`
branchType=`get_branch_type $fullBranchName`

if [ $branchType == "develop" ]; then
  shortBranchName=`shorten_branch_name $fullBranchName`
  appBuild="$appBuild.$shortBranchName"
fi

/usr/libexec/PlistBuddy -c "Set :CFBundleVersion $appBuild" "${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"

echo "Updated build to $appBuild in ${TARGET_BUILD_DIR}/${INFOPLIST_PATH}"
