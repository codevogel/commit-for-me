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
Type "# Run cfme to generate commit message candidates"
Sleep 50ms
Enter
Type "# pick from the candidates,"
Sleep 50ms
Enter
Type "# and then review/edit the chosen message,"
Sleep 50ms
Enter
Type "# before finally committing the changes."
Sleep 50ms
Enter 2
Sleep 500ms
Type "cfme"
Sleep 750ms
Enter
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
Sleep 500ms
Type "# We have committed the changes with the chosen message!"
Sleep 1000ms
Enter 2
Type "# Cool! Now let's look at some additional options:"
Sleep 500ms
Enter 2
Type "# Supply additional instructions on generating the messages:"
Sleep 500ms
Enter 2
Type "git reset --soft HEAD~1 # Undo last commit so we can run the demo again"
Sleep 500ms
Enter 2
Type "cfme \"
Sleep 50ms
Enter 
Type "--instructions 'These are not real changes, the header should be in ALL CAPS.' \"
Sleep 50ms
Enter
Type "--response \"
Sleep 50ms
Enter
Type "--silent \"
Sleep 50ms
Enter
Type "# -r prints the response only (useful for piping), -s suppresses debug output"
Sleep 750ms
Enter
Wait+Screen@30000ms /commitMessages/
Sleep 3000ms
Enter
Type "# You get the idea! Here are some more options, we won't run them now:"
Sleep 750ms
Enter 2
Type "# Supplying a custom prompt and prompt variables file:"
Sleep 250ms
Enter
Type "#    cfme -p my-prompt.md -v my-variables.yaml"
Sleep 250ms
Enter 2
Type "# Print the parsed prompt only (useful for debugging):"
Sleep 250ms
Enter
Type "#    cfme --print-parsed-prompt"
Sleep 250ms
Enter 2
Type "# Printing the reviewed message instead of committing:"
Sleep 250ms
Enter
Type "#    cfme --message (useful for piping to other tools)"
Sleep 250ms
Enter 2
Type "# Remember, you can easily customize cfme to use prompts that fit our own workflow!"
Sleep 50ms
Enter
Type "# Be sure to check out the documentation for more details."
Sleep 750ms
Enter 2
Type "# Now, go download cfme, and thanks for watching!"
Sleep 500ms
Enter
Type "# - codevogel 🐦 (codevogel.com)"
Sleep 3000ms
