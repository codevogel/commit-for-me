function validate_vars_map() {
  local -n referenced_map="$1"
  local prompt="$2"

  # Validate: ensure all placeholders in prompt are in referenced_map
  for tmpl in $(grep -oP '<__[^>]+__>' <<<"$prompt" | sort -u); do
    if [[ -z "${referenced_map[$tmpl]+_}" ]]; then
      echo "Error: custom template string '$tmpl' was found in the prompt file, but is not present in the variables file." >&2
      return 1
    fi
  done

  # Validate: ensure all keys in referenced_map exist in prompt
  for key in "${!referenced_map[@]}"; do
    if [[ "$key" == "<__INSTRUCTIONS__>" ]]; then
      # This key is optional
      continue
    fi
    if ! grep -q "$key" <<<"$prompt"; then
      if [[ "$key" == "<__RESPONSE_FORMAT_REQUIREMENTS__>" || "$key" == "<__GIT_DIFF__>" ]]; then
        # This key is mandatory
        echo "Error: key '$key' is essential for cfme to function, but not present in the prompt." >&2
        return 1
      fi
      echo "Error: custom key '$key' was found in variables, but not present in the prompt." >&2
      return 1
    fi
  done
}
