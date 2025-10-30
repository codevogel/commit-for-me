pick_from_headers() {
  local -n headers_ref=$1
  local response="$2"

  # Quit if no headers are provided
  if [[ ${#headers_ref[@]} -eq 0 ]]; then
    echo "No headers available to pick from. Maybe the AI response is empty or incorrectly formatted? You can test this by running the command again with the -r flag." >&2
    return 1
  fi

  # Prerender all full messages to a temp file
  local temp_file=$(mktemp)
  local count=1 # Start at 1 to match nl numbering
  while IFS= read -r header; do
    local header_only="${header#* }" # Remove score prefix
    echo "=== MESSAGE $count ===" >>"$temp_file"
    echo "$response" | yq eval ".commitMessages[] | select(.header==\"$header_only\") | .header" - >>"$temp_file"
    local body=$(echo "$response" | yq eval ".commitMessages[] | select(.header==\"$header_only\") | .body // \"\"" -)
    local footer=$(echo "$response" | yq eval ".commitMessages[] | select(.header==\"$header_only\") | .footer // \"\"" -)
    [[ -n "$body" && "$body" != "null" ]] && echo "" >>"$temp_file" && echo "$body" >>"$temp_file"
    [[ -n "$footer" && "$footer" != "null" ]] && echo "" >>"$temp_file" && echo "$footer" >>"$temp_file"
    echo "" >>"$temp_file"
    ((count++))
  done < <(printf '%s\n' "${headers_ref[@]}" | sort -rn)

  # Add a final marker to ensure the last message is captured correctly
  echo "=== END ===" >>"$temp_file"

  selected_line=$(printf '%s\n' "${headers_ref[@]}" | sort -rn | nl -w1 -s' ' | fzf --ansi \
    --prompt="Select commit message: " \
    --preview "sed -n '/=== MESSAGE {1} ===/,/=== MESSAGE/p' '$temp_file' | head -n -1 | tail -n +2" \
    --preview-window=wrap)

  local exit_code=$?
  rm -f "$temp_file"

  [[ -z "$selected_line" ]] && {
    echo "No selection, aborting." >&2
    return 1
  }

  # Remove the line number and score prefix
  echo "${selected_line#* }" | sed 's/^[0-9]* //'
}
