fetch_file_if_not_exist() {
  local file_path="$1"
  local fetch_url="$2"

  if [ ! -f "$file_path" ]; then
    print_if_not_silent "File '$file_path' does not exist."
    fetch_file "$file_path" "$fetch_url"
    return $?
  fi
}
