set -U fish_greeting
set -g prompt_dir_size (math floor (tput cols)/6)
set -g fish_key_bindings fish_vi_key_bindings

set -g DEVKITPRO /opt/devkitpro
set -g DEVKITARM /opt/devkitpro/devkitARM
set -g DEVKITPPC /opt/devkitpro/devkitPPC

fish_add_path -a /home/radar77/.cargo/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
    bind \t accept-autosuggestion
    alias "nvchad"="NVIM_APPNAME=nvchad nvim"
    alias "snacks"="NVIM_APPNAME=snacks-nvim nvim"
    alias "deref"='cd $(realpath .)'
    alias "e"='$EDITOR'

    export DEVKITPRO=$(echo $DEVKITPRO)
    export DEVKITARM=$(echo $DEVKITARM)
    export DEVKITPPC=$(echo $DEVKITPPC)
end

function fish_title
    set -l current_cmd (status current-command)
    if test "$current_cmd" = "fish"
        set current_cmd "idle"
    end
    string join '' -- (whoami) " | " (prompt_pwd) " ($current_cmd)"
end

function fish_prompt
    string join '' -- " " (set_color -o white) (whoami) (set_color 74c7ec) " | " (prompt_pwd --dir-length $prompt_dir_size) (set_color normal) " > "
end

function update_vars --on-event fish_postexec
    set -g prompt_dir_size (math floor (tput cols)/20)
end

if command -q nix-your-shell
  nix-your-shell fish | source
end

function sf
    argparse 'q/query=' -- $argv
    or return

    set -l path .
    set -l query ""

    if test (count $argv) -gt 0
        set path $argv[1]
    end
    
    # fish creates _flag_X from argparse. since our long form flag
    # is called query, the variable is _flag_query
    if set -q _flag_query
        set query $_flag_query
    end

    set -l loc (fd . -H --exclude .git "$path" | fzf --query="$query")

    test -f "$loc"; and $EDITOR "$loc"
    test -d "$loc"; and cd "$loc"
end

starship init fish | source


# BEGIN opam configuration
# This is useful if you're using opam as it adds:
#   - the correct directories to the PATH
#   - auto-completion for the opam binary
# This section can be safely removed at any time if needed.
test -r '/home/radar77/.opam/opam-init/init.fish' && source '/home/radar77/.opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true
# END opam configuration

set -q GHCUP_INSTALL_BASE_PREFIX[1]; or set GHCUP_INSTALL_BASE_PREFIX $HOME ; set -gx PATH $HOME/.cabal/bin /home/radar77/.ghcup/bin $PATH # ghcup-env
set -gx PATH $(go env GOPATH)/bin $PATH ; 
