Describe 'validate_vars_map'
    Include src/lib/validate_vars_map.sh
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

    It 'validates variables successfully when everything matches'
        local -A map
        map["<__RESPONSE_REQUIREMENTS__>"]="SAMPLE_REQUIREMENTS"
        map["<__GIT_DIFF__>"]="SAMPLE_DIFF"
        map["<__VAR1__>"]="VAL1"
        map["<__VAR2__>"]="VAL2"
        map["<__VAR3__>"]="VAL3"
        map["<__INSTRUCTIONS__>"]="SAMPLE_INSTRUCTIONS"
        local variables_file_path="/path/to/variables.yaml"
        local prompt="$(cat spec/samples/sample-prompt-complete.md)"
        When call validate_vars_map map "$prompt" 
        The status should be success
    End

    It 'fails when a prompt is missing a custom variable present in the map'
        local -A map
        map["<__RESPONSE_REQUIREMENTS__>"]="SAMPLE_REQUIREMENTS"
        map["<__GIT_DIFF__>"]="SAMPLE_DIFF"
        map["<__VAR1__>"]="VAL1"
        map["<__VAR2__>"]="VAL2"
        map["<__VAR3__>"]="VAL3"
        map["<__INSTRUCTIONS__>"]="SAMPLE_INSTRUCTIONS"
        local variables_file_path="/path/to/variables.yaml"
        local prompt="$(cat spec/samples/sample-prompt-missing-1.md)"
        When call validate_vars_map map "$prompt"
        The stderr should eq "Error: custom key '<__VAR1__>' was found in variables, but not present in the prompt."
        The status should be failure
    End

    It 'fails when a prompt is missing mandatory template string RESPONSE_REQUIREMENTS in the prompt'
        local -A map
        map["<__RESPONSE_REQUIREMENTS__>"]="SAMPLE_REQUIREMENTS"
        map["<__GIT_DIFF__>"]="SAMPLE_DIFF"
        map["<__VAR1__>"]="VAL1"
        map["<__VAR2__>"]="VAL2"
        map["<__VAR3__>"]="VAL3"
        map["<__INSTRUCTIONS__>"]="SAMPLE_INSTRUCTIONS"
        local variables_file_path="/path/to/variables.yaml"
        local prompt="$(cat spec/samples/sample-prompt-missing-requirements.md)"
        When call validate_vars_map map "$prompt"
        The stderr should eq "Error: key '<__RESPONSE_REQUIREMENTS__>' is essential for cfme to function, but not present in the prompt."
        The status should be failure
    End

    It 'fails when a prompt is missing mandatory template string GIT_DIFF in the prompt'
        local -A map
        map["<__RESPONSE_REQUIREMENTS__>"]="SAMPLE_REQUIREMENTS"
        map["<__GIT_DIFF__>"]="SAMPLE_DIFF"
        map["<__VAR1__>"]="VAL1"
        map["<__VAR2__>"]="VAL2"
        map["<__VAR3__>"]="VAL3"
        map["<__INSTRUCTIONS__>"]="SAMPLE_INSTRUCTIONS"
        local variables_file_path="/path/to/variables.yaml"
        local prompt="$(cat spec/samples/sample-prompt-missing-diff.md)"
        When call validate_vars_map map "$prompt"
        The stderr should eq "Error: key '<__GIT_DIFF__>' is essential for cfme to function, but not present in the prompt."
        The status should be failure
    End

    It 'fails when a map is missing a variable present in the prompt'
        local -A map
        map["<__RESPONSE_REQUIREMENTS__>"]="SAMPLE_REQUIREMENTS"
        map["<__GIT_DIFF__>"]="SAMPLE_DIFF"

        map["<__VAR2__>"]="VAL2"
        map["<__VAR3__>"]="VAL3"
        map["<__INSTRUCTIONS__>"]="SAMPLE_INSTRUCTIONS"
        local variables_file_path="/path/to/variables.yaml"
        local prompt="$(cat spec/samples/sample-prompt-complete.md)"
        When call validate_vars_map map "$prompt"
        The stderr should eq "Error: custom template string '<__VAR1__>' was found in the prompt file, but is not present in the variables file."
        The status should be failure
    End
End
