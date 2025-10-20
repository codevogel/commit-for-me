Describe 'select_entry'
    Include src/lib/select_entry.sh
    Include spec/helpers/load_default_env.sh
    Include spec/helpers/unload_default_env.sh

    setup() {
        load_default_env
        export SAMPLE_RESPONSE="$(cat spec/samples/sample-ai-response.yaml)"
    }

    teardown() {
        rm -rf "${CFME_CONFIG_DIR}"
        unset SAMPLE_RESPONSE
        unload_default_env
    }

    BeforeEach 'setup'
    AfterEach 'teardown'

    Describe 'selects the correct entry based on user choice'
      Parameters
        "1"
        "2"
        "3"
        "4"
        "5"
      End

      Example "for entry $1"
        When call select_entry "$1 entry header" "$SAMPLE_RESPONSE"
        The output should eq "$(cat spec/samples/sample-selected-entry-$1.yaml)"
      End
    End
End
