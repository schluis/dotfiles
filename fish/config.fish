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



# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /usr/bin/conda
    eval /usr/bin/conda "shell.fish" "hook" $argv | source
else
    if test -f "/usr/etc/fish/conf.d/conda.fish"
        . "/usr/etc/fish/conf.d/conda.fish"
    else
        set -x PATH "/usr/bin" $PATH
    end
end
# <<< conda initialize <<<

