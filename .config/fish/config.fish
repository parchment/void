alias bye='sudo shutdown -h now'

# Interactive shell initialisation
set -gx EDITOR hx

# Fix for Ghostty terminal
if test "$TERM" = xterm-ghostty
    set -gx TERM xterm-256color
end

set fish_greeting

# Hydro configuration options
set --global hydro_color_prompt blue
set --global hydro_color_pwd green
set --global hydro_color_git yellow
set --global hydro_symbol_prompt ">"
set --global hydro_symbol_git_dirty "*"
set --global hydro_symbol_git_ahead "↑"
set --global hydro_symbol_git_behind "↓"

function set_console_colors
    # Set the 16-color palette using printf escape sequences
    printf '\e]P0000000' # Black
    printf '\e]P1FF6188' # Red
    printf '\e]P2A9DC76' # Green
    printf '\e]P3FFD866' # Yellow
    printf '\e]P478B4F3' # Blue
    printf '\e]P5FC9867' # Magenta
    printf '\e]P6AB9DF2' # Cyan
    printf '\e]P7C7C7C7' # White
    printf '\e]P8444444' # Bright Black
    printf '\e]P9FF6188' # Bright Red
    printf '\e]PAAA9DC76' # Bright Green
    printf '\e]PBFFD866' # Bright Yellow
    printf '\e]PC78B4F3' # Bright Blue
    printf '\e]PDFC9867' # Bright Magenta
    printf '\e]PEAB9DF2' # Bright Cyan
    printf '\e]PFC7C7C7' # Bright White
    clear
end

function setup_console
    if test "$TERM" = linux
        # Your existing color function
        set_console_colors
        # Add font
        sudo setfont spleen-8x16
    end
end

# Auto-apply on shell start
if test "$TERM" = linux
    setup_console
end

# In ~/.config/fish/config.fish
if test -z "$XDG_RUNTIME_DIR"
    set -gx XDG_RUNTIME_DIR /tmp/runtime-(id -u)
    mkdir -p $XDG_RUNTIME_DIR
    chmod 700 $XDG_RUNTIME_DIR
end

set -gx ATUIN_NOBIND true
atuin init fish | source
zoxide init fish | source
bind \cr _atuin_search
bind -M insert \cr _atuin_search
bind \e\[A _atuin_search
bind -M insert \e\[A _atuin_search

if type -q fzf
    set -gx FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border --margin=1 --padding=1"

    # Use bat for syntax highlighting in previews if available
    if type -q bat
        set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --preview 'bat --color=always --style=numbers --line-range=:500 {}'"
    else
        set -gx FZF_DEFAULT_OPTS "$FZF_DEFAULT_OPTS --preview 'cat {}'"
    end

    # Additional fzf configurations for better UX
    set -gx FZF_CTRL_T_OPTS "--preview 'bat --style=numbers --color=always --line-range :500 {}'"
    set -gx FZF_ALT_C_OPTS "--preview 'ls -la {}'"

    # Use fd if available for better performance and respecting gitignore
    if type -q fd
        set -gx FZF_DEFAULT_COMMAND "fd --type f --hidden --follow --exclude .git"
        set -gx FZF_CTRL_T_COMMAND "$FZF_DEFAULT_COMMAND"
        set -gx FZF_ALT_C_COMMAND "fd --type d --hidden --follow --exclude .git"
    end
end

# pnpm
set -gx PNPM_HOME "/home/victor/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end
