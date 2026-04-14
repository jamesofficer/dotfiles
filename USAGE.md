# Chezmoi Usage

## Day-to-day workflow

```bash
# After editing dotfiles in place (e.g. ~/.config/nvim/)
chezmoi re-add

# Commit and push
cd ~/.local/share/chezmoi
git add -A && git commit -m "description" && git push
```

## On another machine

```bash
# First time setup
chezmoi init --apply jamesofficer/dotfiles

# Pull and apply latest changes
chezmoi update
```

## Useful commands

```bash
chezmoi managed   # List all managed files
chezmoi diff      # Show what apply would change
chezmoi add FILE  # Start managing a new file
```
