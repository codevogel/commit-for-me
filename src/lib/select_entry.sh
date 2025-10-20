select_entry() {
  local selected_header="$1"
  local response="$2"

  echo "$(echo "$response" | yq eval ".commitMessages[] | select(.header==\"$selected_header\")" -)"
}
