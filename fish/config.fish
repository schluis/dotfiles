if status is-interactive
    # Commands to run in interactive sessions can go here

  starship init fish | source
  zoxide init fish | source

end

# Aliases
alias ls="ls -G"
alias l="ll"


fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

