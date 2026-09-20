#!/usr/bin/env zsh

### SDKMAN Autocomplete for Oh My Zsh

_sdk() {
	case "${CURRENT}" in
	2)
		compadd -X $'Commands:\n' -- "${${(Mk)functions[@]:#__sdk_*}[@]#__sdk_}"
		compadd -n rm
		;;
	3)
		case "${words[2]}" in
		l|ls|list|i|install)
			compadd -X $'Candidates:\n' -- "${SDKMAN_CANDIDATES[@]}"
			;;
		ug|upgrade|h|home|c|current|u|use|d|default|rm|uninstall)
			compadd -X $'Installed Candidates:\n' -- "${${(u)${(f)$(find -L -- "${SDKMAN_CANDIDATES_DIR}" -mindepth 2 -maxdepth 2 -type d)}[@]:h}[@]:t}"
			;;
		e|env)
			compadd init
			;;
		offline)
			compadd enable disable
			;;
		selfupdate)
			compadd force
			;;
		flush)
			compadd archives broadcast temp version
			;;
		esac
		;;
	4)
		case "${words[2]}" in
		i|install)
			setopt localoptions kshglob
			# __sdkman_list_versions only exists once sdkman-init.sh has run; the
			# zshrc's lazy `sdk()` stub skips that until `sdk` is actually invoked,
			# which completion bypasses entirely. Load it here instead, once.
			(( $+functions[__sdkman_list_versions] )) || source "$SDKMAN_DIR/bin/sdkman-init.sh"
			if [[ "${words[3]}" == 'java' ]]; then
				# Each row is "vendor | use | version | identifier" — only the
				# identifier is a valid `sdk install java <id>` argument, so it
				# must be the completion match. Passing the whole row as the
				# match (as before) made zsh backslash-escape every space and
				# "|" in it for safe insertion, which is the wall of "\ " seen
				# in practice. -d pairs the full row (display only, never
				# escaped/inserted) with the identifier (the real match); -l
				# stops zsh from packing two rows per screen line.
				#
				# After the version table, __sdkman_list_versions' output has
				# a trailing "==== / legend / ---- / usage hints" block with
				# no pipes in it at all — filtering on "has 3 pipes" isolates
				# real rows regardless of how many trailing lines that block
				# is (a fixed line-count slice broke here since SDKMAN added
				# a 3-line usage hint after the legend at some point).
				local -a _sdk_java_rows _sdk_java_ids
				_sdk_java_rows=("${(M)${(f)$(__sdkman_list_versions "${words[3]}")}[@]:#*\|*\|*\|*}")
				_sdk_java_rows=("${_sdk_java_rows[@]:#*Identifier}")  # drop the header row
				_sdk_java_ids=("${_sdk_java_rows[@]##*| }")
				compadd -X $'Installable Versions of java:\n' -l -d _sdk_java_rows -- "${_sdk_java_ids[@]}"
			else
				compadd -X "Installable Versions of ${words[3]}:"$'\n' -- "${${(z)${(M)${(f)${$(__sdkman_list_versions "${words[3]}")//[*+>]+( )/-}}[@]:# *}[@]}[@]:#-*}"
			fi
			;;
		h|home|u|use|d|default|rm|uninstall)
			compadd -X "Installed Versions of ${words[3]}:"$'\n' -- "${${(f)$(find -L -- "${SDKMAN_CANDIDATES_DIR}/${words[3]}" -mindepth 1 -maxdepth 1 -type d -not -name 'current')}[@]:t}"
			;;
		esac
		;;
	5)
		case "${words[2]}" in
		i|install)
			_files -X "Path to Local Installation of ${words[3]} ${words[4]}:"$'\n' -/
			;;
		esac
		;;
	esac
}

compdef _sdk sdk
