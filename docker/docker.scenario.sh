#! /bin/bash

function usage(){
	echo "Usage:"
	for i in get_project_id \
			create_docker_machine_1 \
			install_docker_machine \
			get_info_docker_machine_1 \
			allow_9292_port \
			connect_post_comment_to_network \
			run_monitoring \
			stop_monitoring \
			down_monitoring \
			run_app \
			stop_app \
			down_app 
	do
		echo "$0 $i"
	done
}

function run_monitoring(){
	docker-compose -f docker-compose-monitoring.yml up -d
}

function stop_monitoring(){
	docker-compose -f docker-compose-monitoring.yml stop
}

function down_monitoring(){
        docker-compose -f docker-compose-monitoring.yml down
}

function run_app(){
	docker-compose  up -d
}

function stop_app(){
	docker-compose stop
}

function down_app(){
        docker-compose down
}

function connect_to_network(){
	network_name=$1
	container_name=$2
	echo "Connecting container [$container_name] to the network [$network_name]"
	docker network connect front_net post
}

function install_docker_machine(){
	base=https://github.com/docker/machine/releases/download/v0.16.0 &&
  	curl -L $base/docker-machine-$(uname -s)-$(uname -m) >/tmp/docker-machine &&
  	sudo install /tmp/docker-machine /usr/local/bin/docker-machine &&
	docker-machine version
}

function get_info_docker_machine(){
	machine_name=$1
	echp "Getting info about docker machine name [$machine_name]"
	docker-machine env $machine_name
}
function create_docker_machine(){
	export GOOGLE_PROJECT=$(./docker.scenario.sh get_project_id) && echo "GOOGLE_PROJECT: $GOOGLE_PROJECT"
	machine_name=$1
	echo "Creating docker machine with name [$machine_name]"
	if [ -z "$machine_name" ]; then
                echo "Docker machine name is empty"
        fi
	docker-machine create --driver google \
 		--google-machine-image https://www.googleapis.com/compute/v1/projects/ubuntu-os-cloud/global/images/family/ubuntu-1604-lts \
 		--google-machine-type n1-standard-1 \
 		--google-zone europe-west1-b \
 		$machine_name &&
	get_info_docker_machine $machine_name &&
	docker-machine ls &&
	eval $(docker-machine env docker-host)
}

function create_firewall_rule(){
	rule_name=$1
	rule_port=$2
	if [ -z "$rule_name" ] || [ -z "$rule_port" ]; then
                echo "Rule name or rule port are empty"
        fi

	echo "Creating firewall rule [$rule_name] for [tcp:$rule_port]"
	gcloud compute firewall-rules create $rule_name \
 		--allow tcp:$rule_port \
 		--target-tags=docker-machine \
 		--description="Allow tcp:$rule_port" \
 		--direction=INGRESS
}

case $1 in
	get_project_id)
	echo "docker-245318"
	;;
	
	create_docker_machine_1)
	create_docker_machine docker-host
	;;

	install_docker_machine)
	install_docker_machine
	;;
	
	get_info_docker_machine_1)
	get_info_docker_machine docker-host
	;;

	allow_9292_port)
	create_firewall_rule reddit-app 9292
	;;

	connect_post_comment_to_network)
	connect_to_network front_net post
	connect_to_network back_net comment
	;;

	run_monitoring)
	run_monitoring
	;;

	stop_monitoring)
	stop_monitoring
	;;

	down_monitoring)
	down_monitoring
	;;

	run_app)
	run_app
	;;
	
	stop_app)
	stop_app
	;;

	down_app)
	down_app
	;;

	*)
	usage
	;;
esac

# docker run --rm --pid host -ti tehbilly/htop
# docker run --rm -ti tehbilly/htop
# eval $(docker-machine env dockeer-host)

