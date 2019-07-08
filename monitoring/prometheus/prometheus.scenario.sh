#! /bin/bash
source setenv.sh

function usage(){
	echo "Usage:"
	for i in run_prometheus \
		stop \
		build_prometheus \
		build_app \
  		push_images_to_dockerhub
		
	do
		echo "$0 $i"
	done
}

function push_images_to_dockerhub(){
	docker login
	docker push $USER_NAME/ui
	docker push $USER_NAME/comment
	docker push $USER_NAME/post
	docker push $USER_NAME/prometheus
	docker push $USER_NAME/alertmanager
}

function run_prometheus(){
	echo "Running prometheus server with container name [$PROMETHEUS_CONTAINER_NAME], port [$PROMETHEUS_PORT]"
	 docker run --rm -p $PROMETHEUS_PORT:9090 -d --name $PROMETHEUS_CONTAINER_NAME prom/prometheus:v2.1.0
}

function stop(){
	echo "Stopping container name [$PROMETHEUS_CONTAINER_NAME]"
	docker container stop $PROMETHEUS_CONTAINER_NAME
}

function build_prometheus(){
	export USER_NAME
	docker build -t $USER_NAME/prometheus .
}

function build_app(){
	for i in comment post-py ui 
		do 
		cd /src/$i
		bash docker_build.sh
		cd - 
	done
}

case $1 in
	push_images_to_dockerhub)
	push_images_to_dockerhub
	;;

	run_prometheus)
	run_prometheus
	;;
	
	stop)
	stop
	;;

	build_prometheus)
	build_prometheus
	;;

	build_app)
	build_app
	;;

	*)
	usage
	;;
esac
