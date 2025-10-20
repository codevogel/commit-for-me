get_file_paths() {
  local prompt_file_override="$1"
  local variables_file_override="$2"
  echo "${prompt_file_override:-$CFME_DEFAULT_PROMPT_FILE} ${variables_file_override:-$CFME_DEFAULT_PROMPT_VARIABLES_FILE}"
}
