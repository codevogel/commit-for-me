# Generate directories for configuration
mkdir -p $CFME_CONFIG_DIR
mkdir -p $CFME_PROMPT_DIR
mkdir -p $CFME_PROMPT_DIR/$CFME_PROMPT_TYPE

flag_silent=${args[--silent]:-}

if [[ $flag_silent == "1" ]]; then
  export SILENT_RUN="true"
elif [[ "$CFME_SILENT_MODE" == "true" ]]; then
  export SILENT_RUN="true"
fi

if [[ "$CFME_PROMPT_TYPE" == "conventional-commits" ]]; then
  fetch_file_if_not_exist "$CFME_DEFAULT_PROMPT_FILE" "$CFME_DEFAULT_PROMPT_FILE_FETCH_URL"
  fetch_file_if_not_exist "$CFME_DEFAULT_PROMPT_VARIABLES_FILE" "$CFME_DEFAULT_PROMPT_VARIABLES_FILE_FETCH_URL"
  return 0
fi

fetch_custom_default_file_if_not_exist \
  "$CFME_DEFAULT_PROMPT_FILE" \
  "\$CFME_DEFAULT_PROMPT_FILE" \
  "$CFME_DEFAULT_PROMPT_FILE_FETCH_URL" \
  "\$CFME_DEFAULT_PROMPT_FILE_FETCH_URL" \
  "https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default.md"

fetch_custom_default_file_if_not_exist \
  "$CFME_DEFAULT_PROMPT_VARIABLES_FILE" \
  "\$CFME_DEFAULT_PROMPT_VARIABLES_FILE" \
  "$CFME_DEFAULT_PROMPT_VARIABLES_FILE_FETCH_URL" \
  "\$CFME_DEFAULT_PROMPT_VARIABLES_FILE_FETCH_URL" \
  "https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default-vars.yaml"
