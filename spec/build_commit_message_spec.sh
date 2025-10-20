Describe 'build_commit_message'
    Include src/lib/build_commit_message.sh
    Include spec/helpers/load_default_env.sh
    Include spec/helpers/unload_default_env.sh

    setup() {
        load_default_env
        export SAMPLE_COMMIT_TEMPLATE_COMMENT="$(cat spec/samples/sample-commit-message-template-comment.txt)"
        export TEMP_EXPECTED_COMMIT_MESSAGE_FILE="$(mktemp)"
    }

    teardown() {
        rm -rf "${CFME_CONFIG_DIR}"
        rm -f "${TEMP_EXPECTED_COMMIT_MESSAGE_FILE}"
        unset SAMPLE_COMMIT_TEMPLATE_COMMENT
        unset TEMP_EXPECTED_COMMIT_MESSAGE_FILE
        unload_default_env
    }

    BeforeEach 'setup'
    AfterEach 'teardown'

    Mock git diff --name-status HEAD
      echo "SAMPLE_GIT_DIFF"
    End

    Describe 'selects the correct entry based on user choice'
      Parameters
        "1"
        "2"
        "3"
        "4"
        "5"
      End

      Example "for entry $1"
        echo "$SAMPLE_COMMIT_TEMPLATE_COMMENT" > "${TEMP_EXPECTED_COMMIT_MESSAGE_FILE}"
        echo "$(cat spec/samples/sample-commit-entry-$1.txt)" >> "${TEMP_EXPECTED_COMMIT_MESSAGE_FILE}"
        When call build_commit_message "$(cat spec/samples/sample-selected-entry-$1.yaml)" 
        The output should eq "$(cat ${TEMP_EXPECTED_COMMIT_MESSAGE_FILE})"
      End
    End
End
