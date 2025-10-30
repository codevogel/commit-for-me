# Where should we write the GIF?
Output lazygit-demo.gif 

# Set up a 1200x600 terminal with 46px font.
Set FontSize 20
Set FontFamily "JetBrains Mono"
Set Width 1200
Set Height 600
Set Theme "Kanagawa"
Set WindowBar Colorful

Type "# Welcome to the lazygit demo for cfme (Commit For Me)! 🐦  "
Sleep 500ms
Enter 2
Type "# We will add some changes, then stage them, and then press Ctrl-a to run cfme."
Sleep 500ms
Enter 2
Type "# cfme will generate a few commit message candidates based on the changes we made,"
Sleep 500ms
Enter 2
Type "# we can then pick one of the candidates,"
Sleep 500ms
Enter 2
Type "# edit or accept one message, and then commit."
Sleep 500ms
Enter 2
Type "echo 'Example changes for demo' > my-changes.example"
Sleep 500ms
Enter
Type "lazygit"
Sleep 500ms
Enter
Sleep 500ms
Type "a"
Sleep 1000ms
Ctrl+A
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
Sleep 2000ms
Type "q"
Sleep 500ms
Type "# We have committed the changes with the chosen message using lazygit!"
Sleep 1000ms
Enter 2
Type "# Remember, you can easily customize cfme to use prompts that fit our own workflow!"
Sleep 50ms
Enter
Type "# Be sure to check out the main demo and documentation for more details."
Sleep 750ms
Enter 2
Type "# Now, go download cfme, and thanks for watching!"
Sleep 500ms
Enter
Type "# - codevogel 🐦 (codevogel.com)"
Sleep 3000ms
