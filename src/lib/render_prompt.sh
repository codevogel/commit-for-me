render_prompt() {
  local prompt="$1"
  local -n referenced_map="$2"
  local substituted_prompt="$prompt"

  for key in "${!referenced_map[@]}"; do
    substituted_prompt="${substituted_prompt//$key/${referenced_map[$key]}}"
  done

  echo "$substituted_prompt"
}
