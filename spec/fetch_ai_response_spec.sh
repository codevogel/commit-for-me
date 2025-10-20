Describe 'fetch_ai_response'
    Include src/lib/fetch_ai_response.sh
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

    
    It 'returns the response from the aichat command'
        Mock aichat
            echo "$1"
        End

        When call fetch_ai_response "Test prompt"
        The output should equal "Test prompt"
    End

    It 'fails gracefully when aichat command fails'
        Mock aichat
            exit 1
        End

        When call fetch_ai_response "Test prompt"
        The status should be failure
        The stderr should equal "Error: Failed to fetch AI response."
    End
End
