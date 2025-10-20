Describe 'print_if_not_silent'
    Include src/lib/print_if_not_silent.sh
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

    It 'prints message when SILENT_RUN is not true'
        When call print_if_not_silent "Test Message"
        The stderr should equal "Test Message" 
    End

    It 'does not print message when SILENT_RUN is true'
        export SILENT_RUN="true"
        When call print_if_not_silent "Test Message"
        The stderr should be blank 
    End
End
