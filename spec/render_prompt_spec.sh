Describe 'render_prompt'
    Include src/lib/render_prompt.sh
    Include spec/helpers/load_default_env.sh
    Include spec/helpers/unload_default_env.sh

    setup() {
        load_default_env
    }

    teardown() {
        rm -rf "${CFME_CONFIG_DIR}"
        unset vars_map
        unload_default_env
    }

    BeforeEach 'setup'
    AfterEach 'teardown'

    It 'renders the prompt correctly with all variables replaced'
        local prompt_template="$(cat spec/samples/sample-prompt-complete.md)"
        declare -A vars_map
        vars_map["<__RESPONSE_FORMAT_REQUIREMENTS__>"]="$(cat spec/samples/sample-response-requirements.md)"
        vars_map["<__GIT_DIFF__>"]="SAMPLE_DIFF"
        vars_map["<__VAR1__>"]="VAL1"
        vars_map["<__VAR2__>"]="VAL2"
        vars_map["<__VAR3__>"]="VAL3"
        vars_map["<__INSTRUCTIONS__>"]="SAMPLE_INSTRUCTIONS"
        When call render_prompt "$prompt_template" vars_map
        The output should equal "$(cat spec/samples/sample-rendered-prompt-with-instructions.md)"
    End

    It 'renders the prompt correctly with empty instructions'
        local prompt_template="$(cat spec/samples/sample-prompt-complete.md)"
        declare -A vars_map
        vars_map["<__RESPONSE_FORMAT_REQUIREMENTS__>"]="$(cat spec/samples/sample-response-requirements.md)"
        vars_map["<__GIT_DIFF__>"]="SAMPLE_DIFF"
        vars_map["<__VAR1__>"]="VAL1"
        vars_map["<__VAR2__>"]="VAL2"
        vars_map["<__VAR3__>"]="VAL3"
        vars_map["<__INSTRUCTIONS__>"]=""
        When call render_prompt "$prompt_template" vars_map
        The output should equal "$(cat spec/samples/sample-rendered-prompt-without-instructions.md)"
    End

End
