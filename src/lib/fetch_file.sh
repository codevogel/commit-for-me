fetch_file() {
  local file_path="$1"
  local fetch_url="$2"
  print_if_not_silent "Fetching file from $fetch_url ..."
  curl -fsSL -o "$file_path" "$fetch_url"
  if [ $? -eq 0 ]; then
    print_if_not_silent "File fetched successfully and saved to '$file_path'."
    return 0
  fi
  echo "Failed to fetch file from '$fetch_url'." >&2
  return 1
}
