#!/usr/bin/env bash
set -Eeuo pipefail

ImageName=padavan
ImageTag=rtac51u
HostName=${ImageName}
WorkDir="/work/${ImageName}"
DockerfileDir=$(readlink -f "$(dirname $BASH_SOURCE)")

function usage() {
	cat <<EOF >&2
Usage: $(basename $BASH_SOURCE) [options] [-- <command>]

Options:
   -d|--detach
      start a container in detached mode
      default: $Detach
   -u|--update
      update/rebuild the docker image before run this image
      default: $Update
   -f|--force
      force rebuild the docker image without docker cache
      default: $Force
   -t|--tag
      change image tag to build/run the docker image
      default: $ImageTag
   -h|--help
      show this usage

EOF
}

# options
Detach=false
Update=false
Force=false
Help=false
Opts=$(getopt -o duft:h --long detach,update,force,tag:,help -- "$@")
[[ $? != 0 ]] && { usage; exit 1; }
eval set -- "$Opts"
while true; do
	case "$1" in
		-d|--detach) Detach=true; shift;;
		-u|--update) Update=true; shift;;
		-f|--force)  Update=true; Force=true; shift;;
		-t|--tag)    ImageTag=$2; shift 2;;
		-h|--help)   Help=true; shift;;
		--)          shift; break;;
		*) echo "Arguments parsing error"; exit 1;;
	esac
done

[[ "$Help" == true ]] && { usage; exit 0; }

Image=${ImageName}:${ImageTag}
[[ "$(docker images -q ${Image})" == "" || "$Update" == true ]] && {
	[[ "$Force" == true ]] && BuildOpts="--no-cache" || BuildOpts=""
	docker build ${BuildOpts} -t ${Image} ${DockerfileDir}
}

# prepare mount directories
MountDirOpts="-v $PWD:$WorkDir"

# prepare docker run options
[[ "$Detach" == true ]] && RunOpts="--rm -d" || RunOpts="--rm -it"
RunOpts="${RunOpts} --hostname ${HostName}"
RunOpts="${RunOpts} --workdir ${WorkDir} --env WorkDir=${WorkDir}"
RunOpts="${RunOpts} --env UID=${UID} --env USER=${USER} --env HOME=${HOME}"

# run docker container
docker run ${RunOpts} ${MountDirOpts} ${Image} $@
