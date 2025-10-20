Describe 'fetch_custom_default_file_if_not_exist'
    Include src/lib/fetch_custom_default_file_if_not_exist.sh
    Include spec/helpers/load_default_env.sh
    Include spec/helpers/unload_default_env.sh

    setup() {
        load_default_env
        export FILE_PATH_VAR_NAME="FILE_PATH_VAR_NAME"
        export FETCH_URL_VAR_NAME="FETCH_URL_VAR_NAME"
        export OFFICIAL_FETCH_URL="http://example.com/default_file.md"
        export CFME_PROMPT_TYPE="custom"
    }

    teardown() {
        rm -rf "${CFME_CONFIG_DIR}"
        unset FILE_PATH_VAR_NAME
        unset FETCH_URL_VAR_NAME
        unload_default_env
    }

    BeforeEach 'setup'
    AfterEach 'teardown'

    Mock fetch_file
        echo "Fetched content from $2 into $1"
    End

    It 'does not fetch the file if it already exists'
        mkdir -p "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}"
        local custom_file="${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/custom_prompt.md"
        local custom_url="http://example.com/custom_file.md"
        touch "$custom_file"
        When call fetch_custom_default_file_if_not_exist $custom_file $FILE_PATH_VAR_NAME $custom_url $FETCH_URL_VAR_NAME $OFFICIAL_FETCH_URL
        The output should be blank
        The status should be success
    End

    It 'does not fetch the file if does not exist and no custom URL is provided'
        mkdir -p "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}"
        local custom_file="${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/custom_prompt.md"
        When call fetch_custom_default_file_if_not_exist $custom_file $FILE_PATH_VAR_NAME $OFFICIAL_FETCH_URL $FETCH_URL_VAR_NAME $OFFICIAL_FETCH_URL
        The stderr should include "$FILE_PATH_VAR_NAME ('$custom_file') does not exist."
        The stderr should include "Since you have \$CFME_PROMPT_TYPE set to '$CFME_PROMPT_TYPE' instead of 'conventional-commits', I cannot fetch a default file for you."
        The stderr should include "Please create your own default file, or set a custom \$FETCH_URL_VAR_NAME"
        The status should be failure
    End

    It 'fetches the file if it does not exist and custom URL is provided and user agrees'
        Mock get_choice
            echo "y"
        End

        mkdir -p "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}"
        local custom_file="${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/custom_prompt.md"
        local custom_url="http://example.com/custom_file.md"
        When call fetch_custom_default_file_if_not_exist $custom_file $FILE_PATH_VAR_NAME $custom_url $FETCH_URL_VAR_NAME $OFFICIAL_FETCH_URL
        The stderr should include "$FILE_PATH_VAR_NAME ('$custom_file') does not exist."
        The stderr should include "Since you have \$CFME_PROMPT_TYPE set to '$CFME_PROMPT_TYPE' instead of 'conventional-commits', and have set a custom \$$FETCH_URL_VAR_NAME ('$custom_url'), I can try to fetch the default prompt file from there."
        The stderr should include "Okay then, fetching the file..."
        The output should equal "Fetched content from $custom_url into $custom_file"
        The status should be success
    End

    It 'does not fetch the file if it does not exist and user disagrees'
        Mock get_choice
            echo "n"
        End

        mkdir -p "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}"
        local custom_file="${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/custom_prompt.md"
        local custom_url="http://example.com/custom_file.md"
        When call fetch_custom_default_file_if_not_exist $custom_file $FILE_PATH_VAR_NAME $custom_url $FETCH_URL_VAR_NAME $OFFICIAL_FETCH_URL
        The stderr should include "$FILE_PATH_VAR_NAME ('$custom_file') does not exist."
        The stderr should include "Since you have \$CFME_PROMPT_TYPE set to '$CFME_PROMPT_TYPE' instead of 'conventional-commits', and have set a custom \$$FETCH_URL_VAR_NAME ('$custom_url'), I can try to fetch the default prompt file from there."
        The stderr should include "Exiting..."
        The output should be blank
        The status should be failure
    End

    It 'does not fetch the file if it does not exist and user provides invalid choice'
        Mock get_choice
            echo "x"
        End

        mkdir -p "${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}"
        local custom_file="${CFME_PROMPT_DIR}/${CFME_PROMPT_TYPE}/custom_prompt.md"
        local custom_url="http://example.com/custom_file.md"
        When call fetch_custom_default_file_if_not_exist $custom_file $FILE_PATH_VAR_NAME $custom_url $FETCH_URL_VAR_NAME $OFFICIAL_FETCH_URL
        The stderr should include "$FILE_PATH_VAR_NAME ('$custom_file') does not exist."
        The stderr should include "Since you have \$CFME_PROMPT_TYPE set to '$CFME_PROMPT_TYPE' instead of 'conventional-commits', and have set a custom \$$FETCH_URL_VAR_NAME ('$custom_url'), I can try to fetch the default prompt file from there."
        The stderr should include "Invalid choice. Exiting..."
        The output should be blank
        The status should be failure
    End
End
