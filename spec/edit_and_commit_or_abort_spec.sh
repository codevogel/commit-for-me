Describe 'edit_and_commit_or_abort'
    Include src/lib/edit_and_commit_or_abort.sh
    Include spec/helpers/load_default_env.sh
    Include spec/helpers/unload_default_env.sh

    setup() {
        load_default_env
        export EDITOR="mock_editor"
        export MOCK_EDIT="true"
    }

    teardown() {
        rm -rf "${CFME_CONFIG_DIR}"
        unset EDITOR
        unset MOCK_EDIT
        unload_default_env
    }

    Mock mock_editor
        if [[ "$MOCK_EDIT" == "true" ]]; then
          sleep 0.1
          echo "SAMPLE_ADDITIONAL_LINE" >> "$1"
        fi
    End

    Mock mock_fail_editor
        exit 1
    End
    
    Mock mock_empty_editor
        echo "" > "$1"
    End

    Mock git
        echo "SAMPLE_COMMIT"
    End

    BeforeEach 'setup'
    AfterEach 'teardown'

    It 'commits when editor modifies the file'
        When call edit_and_commit_or_abort "MESSAGE_TEMPLATE" "0"
        The stderr should be blank
        The status should be success
        The output should equal "SAMPLE_COMMIT"
    End

    It 'aborts when editor does not modify the file'
        export MOCK_EDIT="false"
        When call edit_and_commit_or_abort "MESSAGE_TEMPLATE" "0"
        The stderr should equal "File was not saved, aborting."
        The status should be failure
    End

    It 'aborts when editor exits with non-zero status'
        export EDITOR="mock_fail_editor"
        When call edit_and_commit_or_abort "MESSAGE_TEMPLATE" "0"
        The stderr should equal "Editor exited with non-zero status, aborting."
        The status should be failure
    End

    It 'aborts when editor exits with empty commit message'
        export EDITOR="mock_empty_editor"
        When call edit_and_commit_or_abort "MESSAGE_TEMPLATE" "0"
        The stderr should equal "Commit message is empty, aborting."
        The status should be failure
    End

    It 'just prints commit message when flag is set'
        When call edit_and_commit_or_abort "MESSAGE_TEMPLATE" "1"
        The stderr should be blank
        The status should be success
        The output should include "MESSAGE_TEMPLATE"
        The output should include "SAMPLE_ADDITIONAL_LINE"
        The output should not include "SAMPLE_COMMIT"
    End
End
