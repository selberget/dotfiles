
ialias dclean='docker system prune'
alias dex='docker exec --interactive --tty'
ialias di='docker images'
alias dri='docker rmi'
ialias dps='docker ps'
ialias dpsa='docker ps -a'
ialias dsra='docker stop $(docker ps --all --quiet) | xargs docker rm'
ialias dsrr='docker stop $(docker ps --quiet) | xargs docker rm'

dbash() { 
	if [ "$#" -ne "1" ]; then
		printf "dbash requires one argument (container name search string)\n" 1>&2
		return 1
	fi
	
	local container_name_filter="${1}"
	
	local container_id=$(docker ps --quiet --filter "name=${container_name_filter}")

	if [ -z "${container_id}" ]; then
		printf "Running container with name containing '${container_name_filter}' couldn't be found\n" 1>&2
		return 1
	fi
	
	
	docker exec -it "${container_id}" /bin/bash; 
}

