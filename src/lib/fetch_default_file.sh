# Function to fetch a default file if it doesn't exist
fetch_default_file() {
  local file_path="$1"
  local fetch_url="$2"
  local prompt_type="$3"
  local default_url="$4"
  local file_description="$5"
  local recommended_name="$6"

  if [ ! -f "$file_path" ]; then
    print_if_not_silent "Tried to find $file_description at '$file_path', but it does not exist. (This is normal during the very first run.)"

    # If prompt type is non-standard
    if [ "$prompt_type" != "conventional-commits" ]; then
      if [ "$fetch_url" != "$default_url" ]; then
        echo "I have noticed that you have a non-standard \$CFME_PROMPT_TYPE ('$prompt_type') and no local $file_description." &>2
        echo "You have also set a custom fetch URL:" &>2
        echo "  $fetch_url" &>2
        echo "If you intend to fetch your own custom defaults, that’s fine." &>2
        echo "Otherwise, please unset the custom fetch URL environment variable." &>2
        read -p "Are you sure this is what you want to do? (y/n): " choice
        case "$choice" in
        y | Y) echo "Okay then, continuing..." &>2 ;;
        n | N)
          echo "Exiting..." &>2
          exit 1
          ;;
        *)
          echo "Invalid choice. Exiting..." &>2
          exit 1
          ;;
        esac
      else
        echo "Oops! You may have made a mistake." &>2
        echo "Your \$CFME_PROMPT_TYPE is '$prompt_type'." &>2
        echo "The expected $file_description path '$file_path' does not exist." &>2
        echo "Since this is a non-standard prompt type (the standard is '$CFME_PROMPT_TYPE'), I am not able to fetch any defaults for you. So, please create your own file at the following recommended path:" &>2
        echo "  \$CFME_PROMPT_DIR/\$CFME_PROMPT_TYPE/$recommended_name" &>2
        echo "(For you, this resolves to '$CFME_PROMPT_DIR/$CFME_PROMPT_TYPE/$recommended_name')." &>2
        echo "If you really want to, you can use any path for \$CFME_DEFAULT_PROMPT_FILE or \$CFME_DEFAULT_PROMPT_VARIABLES_FILE, in that case, do make sure that those files exist." &>2
        exit 1
      fi
    fi

    print_if_not_silent "Fetching default $file_description from $fetch_url ..."
    curl -fsSL -o "$file_path" "$fetch_url"
    if [ $? -eq 0 ]; then
      print_if_not_silent "Default $file_description fetched successfully."
    else
      echo "Failed to fetch default $file_description." &>2
      exit 1
    fi
    print_if_not_silent "The default $file_description now lives at $file_path"
    print_if_not_silent ""
  fi
}
