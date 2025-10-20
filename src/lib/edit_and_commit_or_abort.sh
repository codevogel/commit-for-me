function edit_and_commit_or_abort() {
  local message_template="$1"
  local flag_print_message="$2"

  tmpfile=$(mktemp)
  echo "$message_template" >"$tmpfile"

  # Record the file's modification time in miliseconds before editing
  original_mtime_ms=$(date -r "$tmpfile" +%s%3N)

  ${EDITOR:-vi} "$tmpfile"

  # Quit if editor was exited with non-zero status
  if [[ $? -ne 0 ]]; then
    echo "Editor exited with non-zero status, aborting." >&2
    rm -f "$tmpfile"
    return 1
  fi

  # Check the file's modification time after editing
  new_mtime_ms=$(date -r "$tmpfile" +%s%3N)

  if [[ "$original_mtime_ms" -eq "$new_mtime_ms" ]]; then
    echo "File was not saved, aborting." >&2
    rm -f "$tmpfile"
    return 1
  fi

  # Quit if editor leaves the commit message empty
  commit_msg="$(<"$tmpfile")"
  if [[ -z "$commit_msg" ]]; then
    echo "Commit message is empty, aborting." >&2
    rm -f "$tmpfile"
    return 1
  fi

  if [[ $flag_print_message == "1" ]]; then
    echo "$commit_msg"
    rm -f "$tmpfile"
    return 0
  fi

  git commit --cleanup=strip -F "$tmpfile"
  rm -f "$tmpfile"
}
