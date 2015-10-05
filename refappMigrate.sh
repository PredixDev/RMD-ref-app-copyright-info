#!/bin/bash
#1. created a list of repos to be migirated .
#2. 
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
			echo "Example: ${bold}./refappMigrate.sh -u owen-ge -p LoveThisJob${normal}"
			exit 1
fi

echo "Starting Migration"
BASEDIR=$(pwd)
BRANCH=master
if [ -d refAppRepo ]
then
    echo "Directory exists deleting"+refAppRepo
    rm -rf refAppRepo
fi

mkdir refAppRepo
chmod 755 migrate_org.sh
cd refAppRepo

git clone --branch $BRANCH https://github.build.ge.com/adoption/predix-rmd-ref-app.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/asset-bootstrap.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/data-seed-service.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/dataingestion-service.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/ext-interface.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/fdh-router-service.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/predix-websocket-server.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/predix-http-datariver.git


git clone --branch $BRANCH https://github.build.ge.com/adoption/machinedata-simulator.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/predix-boot.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/rmd-analytics.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/rmd-datasource.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/rmd-orchestration.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/timeseries-bootstrap.git

# Front end repos
git clone --branch $BRANCH https://github.build.ge.com/adoption/rmd-ref-app-cards.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/ref-list-picker.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/ref-digital-meter.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/rmd-px-data-table.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/rmd-simple-line-chart.git
git clone --branch $BRANCH https://github.build.ge.com/adoption/rmd-ref-app-ui.git

pwd
.././migrate_org.sh -u $user -p $password refAppRepo
