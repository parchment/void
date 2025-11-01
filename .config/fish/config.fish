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
