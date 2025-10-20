Describe 'cfme'
    Include cfme
    Include spec/helpers/load_default_env.sh
    Include spec/helpers/unload_default_env.sh

    setup() {
        load_default_env
        export EDITOR="mock_editor"
        export OUTPUT_FILE="$(mktemp)"
    }

    teardown() {
        rm -rf "${CFME_CONFIG_DIR}"
        unset EDITOR
        rm -f "${OUTPUT_FILE}"
        unset OUTPUT_FILE
        unload_default_env
    }

    BeforeEach 'setup'
    AfterEach 'teardown'

    Mock git
        if [[ "$1" == "commit" ]]; then
            exit 0
        fi
        echo "SAMPLE_DIFF"
    End

    Mock fzf
        echo "header: 1 entry header"
    End

    Mock mock_editor
        sleep .2
        echo "" >> "$1"
    End

    Mock aichat
        echo "$(cat spec/samples/sample-ai-response.yaml)"
    End

    Mock curl 
        path="$3"
        url="$4"
        if [[ "$url" == "https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default.md" ]]; then
            cat "defaults/prompts/conventional-commits/default.md" > "$path"
            exit 0
        elif [[ "$url" == "https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default-vars.yaml" ]]; then
            cat "defaults/prompts/conventional-commits/default-vars.yaml" > "$path"
            exit 0
        else
            echo "Mock curl: URL not recognized" >&2
            exit 1
        fi
    End

    spinner() { 
        echo "SPINNER_STARTED" >&2
    }

     clear_spinner() {
        echo "SPINNER_CLEARED" >&2
     }

    It 'runs sucessfully'
        cp defaults/prompts/conventional-commits/default.md "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default.md"
        cp defaults/prompts/conventional-commits/default-vars.yaml "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default-vars.yaml"
        When call ./cfme
        The output should be blank
        The stderr should not be blank
        The status should be success
    End

    It 'runs sucessfully, silently with -s flag'
        cp defaults/prompts/conventional-commits/default.md "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default.md"
        cp defaults/prompts/conventional-commits/default-vars.yaml "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default-vars.yaml"
        When call ./cfme -s
        The output should be blank
        The stderr should be blank
        The status should be success
    End

    It 'fetches default files sucessfully when they do not exist'
        When call ./cfme
        The output should be blank
        The stderr should include "Fetching file from https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default.md"
        The stderr should include "File fetched successfully and saved to '$CFME_PROMPT_DIR/conventional-commits/default.md'."
        The stderr should include "Fetching file from https://raw.githubusercontent.com/codevogel/commit-for-me/refs/heads/main/defaults/prompts/conventional-commits/default-vars.yaml"
        The stderr should include "File fetched successfully and saved to '$CFME_PROMPT_DIR/conventional-commits/default-vars.yaml'."
        The status should be success
    End

    It 'fails when git diff is empty'
        Mock git
            if [[ "$1" == "commit" ]]; then
                exit 0
            fi
            echo ""
        End

        When call ./cfme
        The output should be blank
        The stderr should include "Error: No staged changes found. Please stage your changes before committing."
        The status should be failure
    End

    It 'prints the response if -r flag is set'
        When call ./cfme -r
        The output should eq "$(cat spec/samples/sample-ai-response.yaml)"
        The status should be success
        The stderr should not be blank
    End

    It 'prints the response silenty if -rs flags are set'
        When call ./cfme -rs
        The output should eq "$(cat spec/samples/sample-ai-response.yaml)"
        The status should be success
        The stderr should be blank
    End

    It 'prints the correct message when -m flag is set'
        When call ./cfme -ms
        The output should eq "$(cat spec/samples/sample-output-commit-message-1.txt)"
        The stderr should be blank
        The status should be success
    End

    It 'prints a correctly parsed prompt when --print-parsed-prompt flag is set'
        cp spec/samples/sample-prompt-complete.md "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default.md"
        cp spec/samples/sample-vars.yaml "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default-vars.yaml"
        When call ./cfme --print-parsed-prompt -s
        The output should eq "$(cat spec/samples/sample-rendered-prompt-without-instructions.md)"
        The stderr should be blank
        The status should be success
    End

    It 'prints a correctly parsed prompt when --print-parsed-prompt flag is set and -i flag is used to pass instructions'
        cp spec/samples/sample-prompt-complete.md "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default.md"
        cp spec/samples/sample-vars.yaml "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default-vars.yaml"
        When call ./cfme --print-parsed-prompt -s -i "SAMPLE_INSTRUCTIONS"
        The output should eq "$(cat spec/samples/sample-rendered-prompt-with-instructions.md)"
        The stderr should be blank
        The status should be success
    End

    It 'prints a correctly parsed prompt when --print-parsed-prompt flag is set and -p and -v flags are used to pass custom prompts and variables'
        export CFME_PROMPT_FILE="${CFME_PROMPT_DIR}/custom.md"
        export CFME_VARS_FILE="${CFME_PROMPT_DIR}/custom-vars.yaml"
        cp spec/samples/sample-prompt-complete.md "${CFME_PROMPT_FILE}" 
        cp spec/samples/sample-vars.yaml "${CFME_VARS_FILE}"
        When call ./cfme --print-parsed-prompt -s -p "${CFME_PROMPT_FILE}" -v "${CFME_VARS_FILE}"
        The output should eq "$(cat spec/samples/sample-rendered-prompt-without-instructions.md)"
        The stderr should be blank
        The status should be success
    End

    It 'prints a correctly parsed prompt when --print-parsed-prompt flag is set and default env variables are set for custom prompts and variables'
        export CFME_DEFAULT_PROMPT_FILE="${CFME_PROMPT_DIR}/custom.md"
        export CFME_DEFAULT_PROMPT_VARIABLES_FILE="${CFME_PROMPT_DIR}/custom-vars.yaml"
        cp spec/samples/sample-prompt-complete.md "${CFME_DEFAULT_PROMPT_FILE}" 
        cp spec/samples/sample-vars.yaml "${CFME_DEFAULT_PROMPT_VARIABLES_FILE}"
        When call ./cfme --print-parsed-prompt -s
        The output should eq "$(cat spec/samples/sample-rendered-prompt-without-instructions.md)"
        The stderr should be blank
        The status should be success
    End

    It 'fails when variables are missing in the vars file that are present in the prompt'
        cp spec/samples/sample-prompt-complete.md "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default.md"
        cp spec/samples/sample-vars-empty.yaml "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default-vars.yaml"
        When call ./cfme
        The output should be blank
        The stderr should include "Error: custom template string '<__VAR1__>' was found in the prompt file, but is not present in the variables file."
        The status should be failure
    End

    It 'fails when variables are missing in the prompt that are present in the vars file'
        echo "" > "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default.md"
        cp spec/samples/sample-vars.yaml "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/default-vars.yaml"
        When call ./cfme
        The output should be blank
        The stderr should include "Error: custom key '<__VAR2__>' was found in variables, but not present in the prompt." #VAR2 shows up as first result due to hashing
        The status should be failure
    End
End
