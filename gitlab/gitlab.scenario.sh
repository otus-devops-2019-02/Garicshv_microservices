#! /bin/bash

HOST=35.246.76.254

function usage(){
	echo "Usage:"
	for i in \
		ssh \
		check \
		ping \
		push	
	do echo "$0 $i"
	done

}



case $1 in
	ssh)
	ssh $HOST
	;;
	
	check)
	curl http://$HOST
	;;

	ping)
	ping $HOST
	;;

	push)
	tag=$(date +%s)
	git add . && git status && git commit -m "tag:2.2.$tag" && git tag 2.2.$tag && git push gitlab gitlab-ci-1 --tags
	;;

	*)
	usage
	;;
esac

