load_default_env() {
  temp_dir=$(mktemp -d)
  export CFME_CONFIG_DIR="${temp_dir}/cfme"
  export CFME_PROMPT_DIR="${CFME_CONFIG_DIR}/prompts"
  export CFME_PROMPT_TYPE="conventional-commits"
  mkdir -p "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}"
  export CFME_DEFAULT_PROMPT_FILE="${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default.md"
  export CFME_DEFAULT_PROMPT_VARIABLES_FILE="${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default-vars.yaml"
  export CFME_SILENT_MODE="false"
  export CFME_DEFAULT_PROMPT_FILE_FETCH_URL="https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default.md"
  export CFME_DEFAULT_PROMPT_VARIABLES_FILE_FETCH_URL="https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default-vars.yaml"
  export CFME_NO_SPINNER="true"
}
