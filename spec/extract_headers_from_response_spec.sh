Describe 'extract_headers_from_response'
    Include src/lib/extract_headers_from_response.sh
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

    It "extracts headers from AI response correctly" 
        response="$(cat spec/samples/sample-ai-response.yaml)"
        When call extract_headers_from_response "$response"
        The output should equal "$(cat spec/samples/sample-extracted-headers-from-response.txt)"
    End
End
