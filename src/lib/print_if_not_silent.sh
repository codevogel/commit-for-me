print_if_not_silent() {
  if [[ "$SILENT_RUN" != "true" ]]; then
    echo "$1" >&2
  fi
}
