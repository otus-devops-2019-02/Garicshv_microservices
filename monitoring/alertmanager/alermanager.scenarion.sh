
export USER_NAME=garichsv

function usage(){
	echo "Usage"
	for i in build
	do
		echo "$0 $i"
	done
}

function build(){
	docker build -t $USER_NAME/alertmanager .
}

case $1 in
	build)
	build
	;;
	
	*)
	usage
	;;
esac
