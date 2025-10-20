fetch_custom_default_file_if_not_exist() {
  local custom_default_file_path="$1"
  local default_file_path_variable_name="$2"
  local custom_default_file_fetch_url="$3"
  local default_file_fetch_url_variable_name="$4"
  local official_default_file_fetch_url="$5"

  if [[ -f "$custom_default_file_path" ]]; then
    return 0
  fi

  echo "$default_file_path_variable_name ('$custom_default_file_path') does not exist." >&2
  if [[ "$custom_default_file_fetch_url" == "$official_default_file_fetch_url" ]]; then
    echo "Since you have \$CFME_PROMPT_TYPE set to '$CFME_PROMPT_TYPE' instead of 'conventional-commits', I cannot fetch a default file for you." >&2
    echo "Please create your own default file, or set a custom \$$default_file_fetch_url_variable_name" >&2
    return 1
  fi
  echo "Since you have \$CFME_PROMPT_TYPE set to '$CFME_PROMPT_TYPE' instead of 'conventional-commits', and have set a custom \$$default_file_fetch_url_variable_name ('$custom_default_file_fetch_url'), I can try to fetch the default prompt file from there." >&2
  choice="$(get_choice "Are you sure this is what you want to do? (y/n): ")"
  case "$choice" in
  y | Y)
    echo "Okay then, fetching the file..." >&2
    fetch_file "$custom_default_file_path" "$custom_default_file_fetch_url"
    ;;
  n | N)
    echo "Exiting..." >&2
    return 1
    ;;
  *)
    echo "Invalid choice. Exiting..." >&2
    return 1
    ;;
  esac
}
