# shellcheck shell=bash

# Format helpers for color_print
green="\033[0;32m"
blue="\033[0;34m"
cyan="\033[0;36m"
yellow="\033[0;33m"
red="\033[0;31m"
default="\033[0m"

function color_print() {
  local color=$1
  local message=$2

  echo -e "${color}${message}${default}\n"
}

function title_print() {
  local message=$1

  echo -e "\n\033[44;1;37m ▸ ${message} ${default}\n"
  sleep 1
}

function prompt() {
  local prompt_message=$1
  local default_value=$2

  echo -n -e "$cyan$prompt_message$default"
  read -r -p" [$default_value]: " input
  input=${input:-$default_value}
}

function random_chars() {
  local count=$1

  chars=$(tr -dc A-Za-z0-9 </dev/urandom | head -c $count)
}

function assert_outside_container() {
  if [[ -n "${RUNNING_IN_CONTAINER-}" ]]; then
    color_print $red "This script must be run out of the container"
    return 1
  fi
}

function should_be_inside_container() {
  if [[ -z "${RUNNING_IN_CONTAINER-}" ]]; then
    color_print $red "This script is intended to be run inside the container"
    return 1
  fi
}

function assert_fs_supports_exec_permission() {
  touch test.sh
  chmod 644 test.sh
  if [[ -x "test.sh" ]]; then
    rm test.sh
    message="ERROR: Your file system does not properly support execute permissions.
If you're using WSL, make sure you checked out the repository within the WSL
filesystem and not into the /mnt/X hierarchy.
This script will terminate now."
    color_print $red "$message"
    exit 1
  fi
  rm test.sh
}
