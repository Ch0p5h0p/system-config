set -U fish_greeting
set -g prompt_dir_size (math floor (tput cols)/6)

fish_add_path -a /home/radar77/.cargo/bin

if status is-interactive
    # Commands to run in interactive sessions can go here
    bind \t accept-autosuggestion
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

starship init fish | source
