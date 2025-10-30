# Where should we write the GIF?
Output demo.gif 

# Set up a 1200x600 terminal with 46px font.
Set FontSize 20
Set FontFamily "JetBrains Mono"
Set Width 1200
Set Height 600
Set Theme "Kanagawa"
Set WindowBar Colorful

Type "# Welcome to the demo for cfme (Commit For Me)! 🐦  "
Sleep 500ms
Enter 2

Type "# Add some changes, then stage them:"
Sleep 500ms
Enter 2

Type "echo 'Example changes for demo' > my-changes.example"
Sleep 500ms
Enter

Type "git add my-changes.example"
Sleep 500ms
Enter 2

Type "# cfme will generate a few commit message candidates based on the changes we made,"
Sleep 50ms
Enter

Type "# we can then pick one of the candidates,"
Sleep 50ms
Enter

Type "# edit or accept one message, and then commit."
Sleep 50ms
Enter 2

Type "cfme"
Sleep 750ms
Enter

# Wait for the screen, then add review changes and save the commit
Wait@30000ms /Select commit/
Sleep 1500ms
Up 1
Sleep 500ms
Up 1
Sleep 1000ms
Enter
Sleep 1000ms
Type "G$a - my review changes"
Ctrl+C
Sleep 3000ms
Type ":wq"
Enter

Sleep 1000ms
Enter 2

Type "# Cool! But we can do more:"
Sleep 500ms
Enter 2

Type "# We can run cfme with custom prompts."
Sleep 500ms
Enter

Type "# For example, let's say your team always writes commit messages in pirate speak."
Sleep 50ms
Enter

Type "# You can create a custom prompt for that! Let's take a look at the pirate prompt:"
Sleep 500ms
Enter 2

Type "cat pirate-prompt.md"
Sleep 500ms
Enter

Sleep 5000ms
Enter 2

Type "# We chose to slot in our 'PIRATE_EXPRESSIONS' with a string from a YAML file:"
Sleep 500ms
Enter 2

Type "cat pirate-vars.yaml"
Sleep 500ms
Enter

Sleep 5000ms
Enter 2

Type "# Now let's run cfme with our custom pirate prompt!"
Enter 2

# Run cfme with the custom prompt and variables, wait for the screen
Type "git reset --soft HEAD~1 # We undo the last commit so we can run the demo again"
Sleep 500ms
Enter 2
Type "# -p will specify the prompt file, -v the variables file"
Sleep 50ms
Enter
Type "# -r will print the AI response directly, -s will run in silent mode"
Sleep 50ms
Enter 2
Type "cfme -p pirate-prompt.md -v pirate-vars.yaml -rs"
Sleep 750ms
Enter
Wait+Screen@30000ms /commitMessages/

Sleep 3000ms
Enter

Type "# You get the idea now! Here are some more options"
Sleep 750ms
Enter 2

Type "# Supply instructions to help the AI process your changes:"
Sleep 250ms
Enter

Type "#    cfme -i 'This commit changes xyz for abc reason'"
Sleep 250ms
Enter 2

Type "# Print the parsed prompt only (useful for debugging):"
Sleep 250ms
Enter

Type "#    cfme --print-parsed-prompt"
Sleep 250ms
Enter 2

Type "# Printing the reviewed message (useful for piping to other tools):"
Sleep 250ms
Enter

Type "#    cfme -m"
Sleep 250ms
Enter 2

Type "# Remember, it is really easy to customize cfme to use prompts that fit your workflow!"
Sleep 50ms
Enter

Type "# Be sure to check out the documentation for more information."
Sleep 750ms
Enter 2

Type "# Now, go download cfme, and thanks for watching!"
Sleep 500ms
Enter

Type "# - codevogel 🐦 (codevogel.com)"
Sleep 3000ms
