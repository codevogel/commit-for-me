# src/lib/fetch_and_wait_for_ai_response.sh

spinner() {
  local pid=$1
  local delay=0.1
  local spin_chars=(⠋ ⠙ ⠹ ⠸ ⠼ ⠴ ⠦ ⠧ ⠇ ⠏)
  local i=0

  while kill -0 "$pid" 2>/dev/null; do
    printf "\r%s" "${spin_chars[$i]}" >&2
    i=$(((i + 1) % ${#spin_chars[@]}))
    sleep "$delay"
  done
}

clear_spinner() {
  printf "\r\033[K" >&2
}

fetch_and_wait_for_ai_response() {
  local prompt="$1"
  local response_file
  local error_file

  if [[ "$SILENT_RUN" == "true" ]]; then
    fetch_ai_response "$prompt"
    return $?
  fi

  response_file=$(mktemp)
  error_file=$(mktemp)

  # Run the actual AI fetch (stderr captured to file)
  fetch_ai_response "$prompt" >"$response_file" 2>"$error_file" &
  local fetch_pid=$!

  spinner "$fetch_pid" &
  local spinner_pid=$!

  wait "$fetch_pid"
  local fetch_status=$?

  # Stop spinner cleanly
  kill "$spinner_pid" 2>/dev/null
  wait "$spinner_pid" 2>/dev/null || true
  clear_spinner

  if [[ $fetch_status -ne 0 ]]; then
    # Print captured error output once
    if [[ -s "$error_file" ]]; then
      echo >&2
      cat "$error_file" >&2
      echo >&2
    fi
    rm -f "$response_file" "$error_file"
    return 1
  fi

  cat "$response_file"
  rm -f "$response_file" "$error_file"
}
