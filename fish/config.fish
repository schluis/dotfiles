# export PATH="/root/.local/bin:$PATH"
export EDITOR=nvim 

if status is-interactive
    # Commands to run in interactive sessions can go here

  starship init fish | source
  zoxide init fish | source

end

# Aliases
alias ls="ls -G"
alias l="ll"
alias copy="xclip -selection clipboard"
alias calc="fend"

alias activate="source .venv/bin/activate.fish"

fish_add_path ~/.local/bin
fish_add_path ~/.cargo/bin

