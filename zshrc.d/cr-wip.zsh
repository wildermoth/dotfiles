# cr-wip-r: print (or run) your project's "cr:wip" with reviewers appended.
cr-wip-r() {
  local pkg script reviewers cmd run=0

  # Optional --run to actually execute the command
  if [[ "${1:-}" == "--run" ]]; then
    run=1
    shift
  fi

  pkg="$(npm prefix 2>/dev/null)/package.json"
  if [[ -z "$pkg" || ! -f "$pkg" ]]; then
    echo "cr-wip-r: package.json not found (are you in a Node project?)" >&2
    return 1
  fi

  # Read scripts["cr:wip"] using Node (works cross-platform)
  script="$(node -e 'const p=require(process.argv[1]);process.stdout.write(p.scripts?.["cr:wip"]||"")' "$pkg")"
  if [[ -z "$script" ]]; then
    echo 'cr-wip-r: scripts["cr:wip"] not found' >&2
    return 1
  fi

  # Default reviewers; add extra emails as args: cr-wip-r alice@x bob@y
  reviewers=",r=szymon@phntms.com,r=pierre.montelle@phntms.com,r=john@phntms.com,r=victor@phntms.com"
  for r in "$@"; do
    reviewers="$reviewers,r=$r"
  done

  # Normalize possible %%wip -> %wip, then append reviewers to %wip
  script="${script//%%wip/%wip}"
  if [[ "$script" == *%wip* ]]; then
    cmd="${script//\%wip/%wip$reviewers}"
  else
    echo "cr-wip-r: warning: no '%wip' found; printing original." >&2
    cmd="$script"
  fi

  echo "$cmd"   # test mode always prints

  # Execute only if --run was used
  if (( run )); then
    eval "$cmd"
  fi
}
