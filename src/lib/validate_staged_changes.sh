validate_staged_changes() {
  local git_diff="$1"
  if [[ -z "$git_diff" ]]; then
    echo "Error: No staged changes found. Please stage your changes before committing." >&2
    return 1
  fi
}
