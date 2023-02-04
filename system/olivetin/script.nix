{ config, pkgs, ... }:

pkgs.writeShellScript "commands.sh" ''
  # OliveTin has nopasswd sudo access to this script, so we want to limit what it can do as root

  function show_usage() {
    printf "Usage: $0 [option] [parameter]]\n"
    printf "\n"
    printf "Options:\n"
    printf " -p|--podman [container name], restart container\n"
    printf " -r|--reboot, Reboot system\n"
    printf " -h|--help, Print help\n"
    return 0
  }

  function restart_podman_container() {
    echo stopping $1
    podman stop $1
    sleep 1
    echo starting $1
    podman start $1
    echo restarted container $1
    return 0
  }

  function restart_server() {
    echo rebooting server
    reboot now
  }

  # Check inputs
  if [[ $# -gt 2 ]] || [[ $# -eq 0 ]];then
    echo "Either 0 or more than 2 input arguments provided which is not supported"
    show_usage
    exit 1
  fi

  if [[ "$1" == "--help" ]] || [[ "$1" == "-h" ]]; then
    show_usage
  elif [[ "$1" == "-p" ]] || [[ "$1" == "--podman" ]]; then
    restart_podman_container $2
  elif [[ $1 == "-r" ]] || [[ "$1" == "--reboot" ]]; then
    restart_server
  else
    echo "Incorrect input provided $1"
    show_usage
  fi
  exit 0
''
