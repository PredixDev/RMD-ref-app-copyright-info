#!/bin/bash
# our intention here is to automate creating the repo on github.com and running the git
# commands needed to 
# 1. pull
# 2. change the remote 
# 3. create orphan branch - basically removing the history
# 4. do a git add on all changed files (changed from S&R)
# 5. do a git commit
# 6. change the tag to the new version number
# 7. move to new branch
# 8. push it all to github.com

user_passed="false"
pass_passed="false"

while getopts ":u:p:" opt; do
  case "$opt" in

	u)
		user="$OPTARG"
		user_passed="true"
	;;
	p)
		password="$OPTARG"
		pass_passed="true"
	;;
	# ? means invalid flag was passed.
	\?)
    	echo "Invalid option: ${bold}-$OPTARG${normal}" >&2
    	exit 1
    ;;
    :)
		echo "the -$OPTARG option requires an argument."
		exit 1
	;;
  esac
done

if [[ $user_passed = "false" ]] || [[ $pass_passed = "false" ]]
		then
			echo "You must pass a user and password combination using the -u for user and -p for password flags."
			echo "Example: ${bold}./migrate_org.sh -u owen-ge -p LoveThisJob${normal}"
			exit 1
fi

#set our vars first!
path="$( cd $(dirname "$0") ; pwd -P )"

migrate () {

#	$1 referes to passed parameter
	dir="$1"

	cd "${path}/refAppRepo/${dir}"
#	find latest tag version
	ver=($(git describe --tags))
#	uptick the patch number
	up_patch=($(echo "${ver%.*}.$((${ver##*.}+1))" ))
	protocol="https://"
	remote_url="github.com/PredixDev/${dir}"
#	do your git magic:

#	change the remote url
	git remote set-url origin ${protocol}${remote_url}.git

#	start a new (orphan) branch
	git checkout --orphan origin master

#	don't forget to add your changed files	
	git add .

#	and commit 'em
	git commit -m "First commit"

#	this will do a force move from old branch to new branch
	git branch -M origin master

#	uptick our tags	
	git tag -a "$up_patch" -m "Initial Public Release."
#
	git config --global credential.helper 'cache --timeout 60'

#	and this will push it, and set it so you don't have to specify where git push goes everytime
	git push --repo ${protocol}${user}:${password}@${remote_url} --set-upstream origin master ${up_patch}

}

create_repo () {
	repo_name="$1"
#	using Github's API, we send a curl request that creates the repo so it's there when we push it.
	curl -X POST -d '{"name":"'${repo_name}'", "private":true}' https://api.github.com/orgs/PredixDev/repos -u ${user}:${password} -H "Content-Type: application/json"
}


main () {
	dir_name=($(echo "$d" | sed 's/\///'))
	create_repo "$dir_name"
	migrate "$dir_name"
}

#loop through the directories
cd refAppRepo
for d in */ ; do
    main
done

#############################################################
# change the following with a multi file find and replace 	#
# build.ge. =												#
# /PXc/ OR /PXd/ = /PredixDev/								#
# sw.ge. =													#
#############################################################