Describe 'pick_from_headers'
    Include src/lib/pick_from_headers.sh
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

    It "picks the top header from the sorted list"
        Mock fzf
            while read -r line; do
                echo "$line"
                break
            done
        End
        mapfile -t headers < spec/samples/sample-extracted-headers-from-response.txt
        When call pick_from_headers headers 
        The output should equal "5 entry header"
        The status should be success
    End

    It "picks the bottom header from the sorted list"
        Mock fzf
            while read -r line; do
                last_line="$line"
            done
            echo "$last_line"
        End
        mapfile -t headers < spec/samples/sample-extracted-headers-from-response.txt
        When call pick_from_headers headers
        The output should equal "1 entry header"
        The status should be success
    End

    It "fails when no headers are provided"
        Mock fzf
            echo "FZF RAN WHEN IT SHOULD NOT HAVE"
        End
        empty_headers=()
        When call pick_from_headers empty_headers
        The status should be failure
        The stderr should include "No headers available to pick from."
    End

    It "fails when no selection was made"
        Mock fzf
            echo ""
        End
        mapfile -t headers < spec/samples/sample-extracted-headers-from-response.txt
        When call pick_from_headers headers
        The status should be failure
        The stderr should include "No selection, aborting."
    End
End
