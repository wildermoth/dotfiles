# cr: run code review helpers; defaults to the raw push command from package scripts.
cr() {
  emulate -L zsh
  setopt local_options no_sh_word_split

  local wip=0
  local use_defaults=0
  local -a extra_reviewers=()

  while (( $# )); do
    case "$1" in
      --wip|-w)
        wip=1
        shift
        ;;
      --reviewers|-r)
        use_defaults=1
        shift
        if (( $# )) && [[ "$1" != -* ]]; then
          extra_reviewers+=("${(@s/,/)1}")
          shift
        fi
        ;;
      --reviewers=*|-r=*)
        use_defaults=1
        extra_reviewers+=("${(@s/,/)${1#*=}}")
        shift
        ;;
      --help|-h)
        cat <<'EOF'
Usage: cr [--wip|-w] [--reviewers|-r [email[,email...]]]

  --wip, -w          Use the cr:wip npm script (adds %wip segment).
  --reviewers, -r    Append default reviewers; optional extra comma-separated emails.
  --help, -h         Show this message.

Without flags this uses scripts["cr"]. Combine flags to add %wip and reviewers.
EOF
        return 0
        ;;
      *)
        echo "cr: unknown option '$1' (try --help)" >&2
        return 1
        ;;
    esac
  done

  local pkg script_key
  pkg="$(npm prefix 2>/dev/null)/package.json"
  if [[ -z "$pkg" || ! -f "$pkg" ]]; then
    echo "cr: package.json not found (are you in a Node project?)" >&2
    return 1
  fi

  script_key=$([[ $wip -eq 1 ]] && printf '%s' 'cr:wip' || printf '%s' 'cr')
  local script
  script="$(node -e 'const p=require(process.argv[1]);const key=process.argv[2];process.stdout.write(p.scripts?.[key]||"")' "$pkg" "$script_key")"
  if [[ -z "$script" ]]; then
    echo "cr: scripts[\"$script_key\"] not found" >&2
    return 1
  fi

  local cmd="$script"
  cmd="${cmd//%%wip/%wip}"

  local append_reviewers=0
  (( use_defaults || ${#extra_reviewers[@]} > 0 )) && append_reviewers=1

  if (( append_reviewers )); then
    local -a default_reviewers=()
    if typeset -p CR_WIP_DEFAULT_REVIEWERS &>/dev/null; then
      default_reviewers=("${CR_WIP_DEFAULT_REVIEWERS[@]}")
    fi
    if (( ${#default_reviewers[@]} == 0 )); then
      default_reviewers=(
        szymon@phntms.com
        pierre.montelle@phntms.com
        john@phntms.com
        victor@phntms.com
      )
    fi

    local -A seen
    local -a unique_reviewers=()
    local r
    for r in "${default_reviewers[@]}"; do
      (( use_defaults )) || continue
      [[ -z "$r" ]] && continue
      if [[ -z ${seen[$r]} ]]; then
        seen[$r]=1
        unique_reviewers+=("$r")
      fi
    done
    for r in "${extra_reviewers[@]}"; do
      [[ -z "$r" ]] && continue
      if [[ -z ${seen[$r]} ]]; then
        seen[$r]=1
        unique_reviewers+=("$r")
      fi
    done

    local reviewers_suffix=""
    for r in "${unique_reviewers[@]}"; do
      reviewers_suffix="$reviewers_suffix,r=$r"
    done

    if [[ "$cmd" == *%wip* ]]; then
      cmd="${cmd//%wip/%wip$reviewers_suffix}"
    else
      cmd="$cmd$reviewers_suffix"
    fi
  else
    # Remove placeholder defensively if script has %wip but caller did not want it.
    [[ $wip -eq 0 ]] && cmd="${cmd//%wip/}"
  fi

  echo "$cmd"

  if [[ ! -t 0 ]]; then
    echo "cr: non-interactive shell; skipping execution." >&2
    return 0
  fi

  printf "Run this command? [y/N] "
  local reply=""
  IFS= read -r reply

  if [[ "$reply" == [yY]* ]]; then
    echo "(test mode) $cmd"
    # TODO: execute command once testing phase is over, e.g., eval "$cmd"
  else
    echo "Aborted."
  fi
}
