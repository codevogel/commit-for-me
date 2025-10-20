Describe 'validate_staged_changes'
    Include src/lib/validate_staged_changes.sh
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

    It 'succeeds when there are staged changes'
        When call validate_staged_changes "some changes"
        The status should be success
        The stderr should be blank
    End

    It 'fails when there are no staged changes'
        When call validate_staged_changes ""
        The status should be failure
        The stderr should eq "Error: No staged changes found. Please stage your changes before committing."
    End
End
