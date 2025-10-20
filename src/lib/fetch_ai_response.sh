fetch_ai_response() {
  local substituted_prompt="$1"
  aichat "$(echo "$substituted_prompt")"
  if [ $? -ne 0 ]; then
    echo "Error: Failed to fetch AI response." >&2
    return 1
  fi
}
