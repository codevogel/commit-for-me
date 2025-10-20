Describe 'fetch_file_spec'
    Include src/lib/fetch_file.sh
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

    Mock curl
        echo "Fetched content from $4 into $3"
    End

    Mock print_if_not_silent
        echo "$1" >&2
    End

    It 'fetches a file from a URL to a specified destination'
        local url="http://example.com/file.txt"
        local destination="/tmp/file.txt"
        When call fetch_file "$destination" "$url"
        The stderr should include "Fetching file from $url ..."
        The stderr should include "File fetched successfully and saved to '$destination'."
        The output should equal "Fetched content from $url into $destination"
        The status should be success
    End

    It 'handles curl failure gracefully'
        Mock curl
            return 1
        End

        local url="http://example.com/file.txt"
        local destination="/tmp/file.txt"
        When call fetch_file "$destination" "$url"
        The stderr should include "Fetching file from $url ..."
        The stderr should include "Failed to fetch file from '$url'."
        The status should be failure
    End
End
