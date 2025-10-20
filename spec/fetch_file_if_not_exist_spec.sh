Describe 'fetch_file_if_not_exist'
    Include src/lib/fetch_file_if_not_exist.sh
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

    Mock fetch_file
        echo "Fetched content from $2 into $1"
    End

    Mock print_if_not_silent
        echo "$1" >&2
    End

    It 'fetches the file if it does not exist'
        local url="http://example.com/file.txt"
        local destination="${CFME_CONFIG_DIR}/file.txt"
        When call fetch_file_if_not_exist "$destination" "$url"
        The stderr should include "File '$destination' does not exist."
        The output should equal "Fetched content from $url into $destination"
        The status should be success
    End

    It 'does not fetch the file if it already exists'
        local url="http://example.com/file.txt"
        local destination="${CFME_CONFIG_DIR}/file.txt"
        touch "$destination"
        When call fetch_file_if_not_exist "$destination" "$url"
        The output should be blank
        The status should be success
    End
End
