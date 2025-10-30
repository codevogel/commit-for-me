# Loads variables from a YAML file into an associative array
# Usage: load_vars_map <array_name> <vars_file>
# Example:
#   declare -A my_vars
#   load_vars_map my_vars "/path/to/vars.yaml"
load_vars_map() {
  local -n referenced_map="$1"
  local vars_file="$2"
  local instructions_override="$3"

  # Get number of vars
  local count
  count=$(yq eval '.vars | length' "$vars_file")

  # Iterate over vars and populate vars_map
  for i in $(seq 0 $((count - 1))); do
    local key value cmd

    # Get template_string
    key=$(yq eval ".vars[$i].template_string" "$vars_file")

    # Get value or value_from
    if yq eval -e ".vars[$i].value_from" "$vars_file" >/dev/null 2>&1; then
      # value_from: execute shell command(s) and capture output as value
      cmd=$(yq eval ".vars[$i].value_from" "$vars_file" | sed 's/^[[:space:]]*//')
      value="$(eval "$cmd")"
    else
      # value: literal string
      value=$(yq eval -o=yaml ".vars[$i].value" "$vars_file")
    fi

    # Save to the map
    referenced_map["$key"]="$value"
  done

  # Add defaults to the map
  referenced_map["<__GIT_DIFF__>"]="$(git diff --cached)"

  referenced_map["<__RESPONSE_FORMAT_REQUIREMENTS__>"]="$(
    cat <<'EOF'
**Response Format Requirements:**

- Each commit message MUST include a 'header'.
- Optionally include 'body' and 'footer', ONLY if a 'header'
  wouldn't suffice to fully describe all changes.
- Attempt to describe everything in the 'header' whenever possible.
- Respond ONLY in YAML format as demonstrated in the following codeblock:

```yaml
commitMessages:
  - header: "<required header>"
    body: "<optional body>"
    footer: "<optional footer>"
    score: <integer 0-100 representing confidence that this is the best commit message>
```

- Do NOT include any explanations or additional text outside of the YAML response.
- The response must be valid YAML.
- The response may not contain any markdown formatting (so no codeblocks).
EOF
  )"

  # if instructions override is not empty, override instructions key.
  # else, do not override potential instructions from file with empty string.
  if [[ -n "$instructions_override" ]]; then
    referenced_map["<__INSTRUCTIONS__>"]="$instructions_override"
  else
    # if reference_map["<__INSTRUCTIONS__>"] was set through the vars file, keep it.
    # else, set it to empty string.
    # this is to allow people to provide a default instructions var if they want to.
    if [[ -z "${referenced_map["<__INSTRUCTIONS__>"]+_}" ]]; then
      referenced_map["<__INSTRUCTIONS__>"]=""
    fi
  fi
}
