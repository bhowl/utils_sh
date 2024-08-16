#!/bin/bash
# A library of utility functions for bash scripting.

# Attempts to print error details.
# @param    additional error message
err_info() {
	local i=$((${#BASH_SOURCE[@]} - 1))
	echo "${BASH_SOURCE[$i]}: line ${BASH_LINENO[1]}: ${FUNCNAME[1]}:" \
		 "${FUNCNAME[2]}: $*"
}

# Prints error info, then returns exit status of 1.
# @param      additional error message
# @returns    exit status
err_return() {
	echo "$(err_info $*)" >&2
	return 1
}

# Prints error info, then returns exit status of 1.
# @param      additional error message
# @returns    exit status
err_exit() {
	echo "$(err_info $*)" >&2
	exit 1
}

# Sources specified file or exits.
# @param    file to source
source_or_exit() {
	local file="$1"
	if [[ -f "$file" ]]; then
		. "$file"
	else
		err_exit "Could not source $file"
	fi
}

# Checks parameters given to script. Looks for one argument to be specified (or exits).
# @param    the script's parameters 
# TODO: add more functions for checking number of args, options vs tokens vs option w/ token
specify_arg() {
	if (( $# < 1 )); then
		err_exit "Please supply one arg when calling script"
	fi
}

# TODO: update 
positional_param1() {
	if [ "$1" != -* ]; then
		err_exit"First arg is a positional parameter"
	fi
}

# Checks the given path-to-directory exists.
# @param      path-to-directory
# @returns    exit status
check_path_exists() {
	local path="$1"
	if ! [[ -d "$path" ]]; then
		err_return "Path doesn't exist: $path"
	fi
}

# Checks the given path-to-directory exists.
# @param      path-to-directory
# @returns    exit status
check_file_exists() {
	local file="$1"
	if ! [[ -e "$file" ]]; then
		err_return "File doesn't exist: $file"
	fi
}

# Prompts terminal for continuation response
# @input      from user
# @returns    exit status
continue_prompt() {
	echo -en "(prompt) Do you want to continue?\t"
	read continue
	if [[ "$continue" == "y" ]]; then
		return 0
	elif [[ "$continue" == "n" ]]; then
		return 1
	else
		echo "Please respond with 'y' or 'n'."
		continue_prompt
	fi
}

# Prints array element per line.
# @param    a bash array
# TODO: add parameter to specifying the command when iterating through array 
print_array() {
	local array=("${@}")
	for element in "${array[@]}"; do
		echo "$element"
	done
}
