extract_headers_from_response() {
  local response="$1"
  echo "$response" | yq eval '.commitMessages[] | "\(.score) \(.header)"' -
}
