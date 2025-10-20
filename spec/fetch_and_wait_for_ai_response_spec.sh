Describe 'fetch_and_wait_for_ai_response'
    Include src/lib/fetch_and_wait_for_ai_response.sh
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

    Mock spinner 
        echo "SPINNER_STARTED" >&2
    End

    Mock clear_spinner
        echo "SPINNER_CLEARED" >&2
    End

    Mock fetch_ai_response
        sleep 0.2
        echo "SAMPLE_RESPONSE"
    End

    It 'returns the response from the aichat command with stderr spinner'
        When call fetch_and_wait_for_ai_response "Sample prompt"
        The output should equal "SAMPLE_RESPONSE"
        The stderr should include "SPINNER_STARTED"
        The stderr should include "SPINNER_CLEARED"
    End

    It 'fails gracefully when aichat command fails with stderr spinner'
        Mock fetch_ai_response
            sleep 0.2
            echo "Simulated error occurred." >&2
            exit 1
        End

        When call fetch_and_wait_for_ai_response "Sample prompt"
        The status should be failure
        The stderr should include "SPINNER_STARTED"
        The stderr should include "SPINNER_CLEARED"
        The stderr should include "Simulated error occurred."
    End
End
