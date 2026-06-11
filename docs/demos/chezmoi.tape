Output chezmoi.gif

Set FontSize 16
Set Width 1400
Set Height 800
Set Theme "Catppuccin Mocha"
Set TypingSpeed 50ms
Set PlaybackSpeed 1.0
Set Shell zsh

Hide
Type "source ~/.zshrc 2>/dev/null; clear"
Enter
Sleep 1s
Show

Type "chezmoi init --apply https://github.com/Livepixelz/dotfiles.git"
Sleep 800ms
Enter
Sleep 4s

Type "clear"
Enter
Sleep 300ms

Type "ls ~/.config/helix/"
Enter
Sleep 1500ms

Type "hx --health vue | head -5"
Enter
Sleep 2s
