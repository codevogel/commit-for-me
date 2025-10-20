Describe 'load_vars_map'
    Include src/lib/load_vars_map.sh
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

    Mock git
        echo "SAMPLE_DIFF"
    End

    It 'loads variables successfully'
        local -A vars_map
        local variables_file_path="spec/samples/sample-vars.yaml"
        local instructions_override="SAMPLE_INSTRUCTIONS"
        When call load_vars_map vars_map "$variables_file_path"
        The variable vars_map["<__VAR1__>"] should equal "VAL1"
        The variable vars_map["<__VAR2__>"] should equal "VAL2"
        The variable vars_map["<__VAR3__>"] should equal "VAL3"
        The variable vars_map["<__GIT_DIFF__>"] should equal "SAMPLE_DIFF"
        The variable vars_map["<__INSTRUCTIONS__>"] should not be undefined
        The variable vars_map["<__INSTRUCTIONS__>"] should be blank 
    End

    It 'loads instructions from file when no override is provided'
        local -A vars_map
        local variables_file_path="spec/samples/sample-vars-with-instructions.yaml"
        When call load_vars_map vars_map "$variables_file_path"
        The variable vars_map["<__VAR1__>"] should equal "VAL1"
        The variable vars_map["<__VAR2__>"] should equal "VAL2"
        The variable vars_map["<__VAR3__>"] should equal "VAL3"
        The variable vars_map["<__GIT_DIFF__>"] should equal "SAMPLE_DIFF"
        The variable vars_map["<__INSTRUCTIONS__>"] should equal "SAMPLE_INSTRUCTIONS_FROM_FILE"
    End

    It 'overwrites instructions from file when override is provided'
        local -A vars_map
        local variables_file_path="spec/samples/sample-vars-with-instructions.yaml"
        When call load_vars_map vars_map "$variables_file_path" "SAMPLE_INSTRUCTIONS"
        The variable vars_map["<__VAR1__>"] should equal "VAL1"
        The variable vars_map["<__VAR2__>"] should equal "VAL2"
        The variable vars_map["<__VAR3__>"] should equal "VAL3"
        The variable vars_map["<__GIT_DIFF__>"] should equal "SAMPLE_DIFF"
        The variable vars_map["<__INSTRUCTIONS__>"] should equal "SAMPLE_INSTRUCTIONS"
    End

    It 'overrides instructions when provided'
        local -A vars_map
        local variables_file_path="spec/samples/sample-vars.yaml"
        local instructions_override="SAMPLE_INSTRUCTIONS"
        When call load_vars_map vars_map "$variables_file_path" "$instructions_override"
        The variable vars_map["<__VAR1__>"] should equal "VAL1"
        The variable vars_map["<__VAR2__>"] should equal "VAL2"
        The variable vars_map["<__VAR3__>"] should equal "VAL3"
        The variable vars_map["<__GIT_DIFF__>"] should equal "SAMPLE_DIFF"
        The variable vars_map["<__INSTRUCTIONS__>"] should equal "SAMPLE_INSTRUCTIONS" 
    End

    It 'loads <__GIT_DIFF__> and <__INSTRUCTIONS__> keys even with empty variables file'
        local -A vars_map
        local variables_file_path="spec/samples/sample-vars-empty.yaml"
        local instructions_override="SAMPLE_INSTRUCTIONS"
        When call load_vars_map vars_map "$variables_file_path" "$instructions_override"
        The variable vars_map["<__VAR1__>"] should be undefined 
        The variable vars_map["<__GIT_DIFF__>"] should equal "SAMPLE_DIFF"
        The variable vars_map["<__INSTRUCTIONS__>"] should equal "SAMPLE_INSTRUCTIONS" 
    End

End
