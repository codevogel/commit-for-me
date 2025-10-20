pick_from_headers() {
  local -n headers_ref=$1

  # Quit if no headers are provided
  if [[ ${#headers_ref[@]} -eq 0 ]]; then
    echo "No headers available to pick from. Maybe the AI response is empty or incorrectly formatted? You can test this by running the command again with the -r flag." >&2
    return 1
  fi

  selected_line=$(printf '%s\n' "${headers_ref[@]}" | sort -rn | fzf --ansi --prompt="Select commit message: " --preview "echo {}")
  [[ -z "$selected_line" ]] && {
    echo "No selection, aborting." >&2
    return 1
  }
  echo "${selected_line#* }"
}
