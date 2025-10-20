get_choice() {
  local prompt_message="$1"
  local choice
  read -p "$prompt_message (y/n): " choice
  echo "$choice"
}
