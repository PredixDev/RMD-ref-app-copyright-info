#!/bin/bash

#set our vars first!
path="$( cd $(dirname "$0") ; pwd -P )"

main () {
	cd "${path}/${d}"
	git pull origin master
}
for d in */ ; do
    main
done