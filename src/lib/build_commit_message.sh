build_commit_message() {
  local selected_entry="$1"

  local tmpfile=$(mktemp)

  echo "# Below is the generated commit message. Alter as needed." >"$tmpfile"
  echo "# Be sure to review the body and footer if present." >>"$tmpfile"
  echo "# If you want to commit with this message, save this file and exit your editor." >>"$tmpfile"
  echo "# If you want to cancel the commit, exit without saving, or save as an empty file." >>"$tmpfile"
  echo "#" >>"$tmpfile"

  local git_diff_name_status="$(git diff --name-status --cached)"
  echo "# Staged changes:" >>"$tmpfile"
  echo "$git_diff_name_status" | while read -r line; do
    echo "# $line" >>"$tmpfile"
  done

  # Extract header, body, footer
  header=$(echo "$selected_entry" | yq eval '.header' -)
  body=$(echo "$selected_entry" | yq eval '.body // ""' -)
  footer=$(echo "$selected_entry" | yq eval '.footer // ""' -)

  # Build commit message according to rules
  {
    echo "$header"
    [[ -n "$body" ]] && echo -e "\n$body"
    [[ -n "$footer" ]] && echo -e "\n$footer"
  } >>"$tmpfile"

  cat $tmpfile
  rm -f "$tmpfile"
}
