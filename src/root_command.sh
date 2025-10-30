instructions_override=${args[--instructions]:-}
prompt_file_override=${args["--prompt-file"]:-}
variables_file_override=${args["--variables-file"]:-}
flag_print_response=${args[--response]:-}
flag_print_message=${args[--message]:-}
flag_print_prompt=${args["--print-parsed-prompt"]:-}

# We check whether there are staged changes to commit, and exit if there are none.
git_diff="$(git diff --cached)"
validate_staged_changes "$git_diff"

# We load the prompt and variable file paths, applying any overrides provided by the user.
read prompt_file_path variable_file_path < <(get_file_paths "$prompt_file_override" "$variables_file_override")
prompt="$(<"$prompt_file_path")"

# We inform the user about the process that is about to take place.
print_if_not_silent "Commit for me will now attempt to generate a commit message based on your staged changes."
print_if_not_silent "Using prompt file at '$prompt_file_path'"
print_if_not_silent "Using prompt variables file at '$variable_file_path'"

# We declare a map to hold the variables from the prompt variables file
declare -A vars_map
load_vars_map vars_map "$variable_file_path" "$instructions_override"
validate_vars_map vars_map "$prompt"

# Substitute variables in the prompt
substituted_prompt=$(render_prompt "$prompt" vars_map)
print_if_not_silent "The prompt substitution was successful."
print_if_not_silent "Now fetching the message candidates from the AI... (this may take a moment)"

if [[ "$flag_print_prompt" == "1" ]]; then
  echo "$substituted_prompt"
  return 0
fi

response=$(fetch_and_wait_for_ai_response "$substituted_prompt")

if [[ "$flag_print_response" == "1" ]]; then
  echo "$response"
  return 0
fi

# Now print message (no blank line)
print_if_not_silent "AI response received. Presenting options for selection..."

# Parse AI response and let user select a commit message
mapfile -t headers < <(extract_headers_from_response "$response")
selected_header="$(pick_from_headers headers "$response")"
selected_entry="$(select_entry "$selected_header" "$response")"

# Build the commit message and open it in the user's editor for review/editing
commit_message="$(build_commit_message "$selected_entry")"
# Finally, open it for review, and commit or abort based on user input
edit_and_commit_or_abort "$commit_message" "$flag_print_message"
if [[ $? -ne 0 ]]; then
  return 1
fi
