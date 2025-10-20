Describe 'get_file_paths'
    Include src/lib/get_file_paths.sh
    Include spec/helpers/load_default_env.sh
    Include spec/helpers/unload_default_env.sh

    setup() {
        load_default_env
    }

    teardown() {
        rm -rf "${CFME_CONFIG_DIR}"
        unload_default_env
    }

    BeforeEach 'setup'
    AfterEach 'teardown'

    It 'returns default file paths when no overrides are provided'
        When call get_file_paths
        The output should equal "${CFME_DEFAULT_PROMPT_FILE} ${CFME_DEFAULT_PROMPT_VARIABLES_FILE}"
    End

    It 'returns overridden file paths when overrides are provided'
        local prompt_file_override="/custom/path/prompt.md"
        local variables_file_override="/custom/path/variables.yaml"
        When call get_file_paths "$prompt_file_override" "$variables_file_override"
        The output should equal "$prompt_file_override $variables_file_override"
    End
End
