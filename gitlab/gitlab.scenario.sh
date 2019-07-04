#! /bin/bash

HOST=35.246.76.254

function usage(){
	echo "Usage:"
	for i in \
		ssh \
		check \
		ping		
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

	*)
	usage
	;;
esac

