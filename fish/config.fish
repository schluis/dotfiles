export PATH="/root/.local/bin:$PATH"

if status is-interactive
    # Commands to run in interactive sessions can go here

  starship init fish | source
  zoxide init fish | source

end

# Aliases
alias ls="ls -G"
alias l="ll"
alias jupyter-notebook="~/.local/bin/jupyter-notebook --no-browser"
alias ssh='ssh.exe'
alias ssh-add='ssh-add.exe'

fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin
