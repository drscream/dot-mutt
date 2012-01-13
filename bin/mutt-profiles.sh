#!/bin/bash
export LC_COLLATE=POSIX
mutt_profile_dir="${HOME}/.mutt/profiles"
while true; do
	declare -a mutt_profile_list
	let c=1
	for p in $(find "${mutt_profile_dir}" -mindepth 1 -maxdepth 1 -type d -not -name ".*" | sort -n); do
		mutt_profile_list[${c}]="${p##*/}" # basename of the directory
		let c++
	done; unset c; unset p

	echo '*** select a profile to use:'
	for ((i=1; i<=${#mutt_profile_list[@]}; i++)); do
		echo "${i}) ${mutt_profile_list[${i}]}"
	done; unset i
	echo 'q) quit'
	echo -n '?: '
	read -e -t 3 -n 1 input_sel
	if [ "${defquit}" = "yes" -a -z "${input_sel}" ] || [ "${input_sel}" = "q" ]; then
		echo "*** exiting"
		exit
	fi
	if [ -n "${input_sel}" ]; then
		selected_profile="${mutt_profile_list[${input_sel}]}"
		rm -f "${mutt_profile_dir}/.current"
		ln -s "${selected_profile}" "${mutt_profile_dir}/.current"
	fi; unset selected_profile
	unset input_sel
	unset mutt_profile_list
	mutt
	defquit=yes
done

