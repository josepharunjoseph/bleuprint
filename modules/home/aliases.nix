# Configurable shell aliases
{ config, lib, pkgs, ... }:

let
  # Configuration option for enabling modern tool replacements
  cfg = config.programs.modernTools;
in
{
  options.programs.modernTools = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable modern CLI tool replacements for traditional commands";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zsh.initExtra = ''
      # Collision-safe aliases - only apply in interactive shells
      if [[ $- == *i* ]]; then
        # File system replacements (safe - no script conflicts)
        alias ls="eza --icons"
        alias ll="eza -l --icons" 
        alias la="eza -la --icons"
        alias lt="eza --tree --icons"
        alias tree="erd"
        
        # File content viewers (conditional to avoid breaking scripts)
        if [[ -t 1 ]] && [[ -z "$BAT_OVERRIDE_LESS" ]]; then
          alias cat="bat"
          # Don't alias less - breaks man pages and scripts
        fi
        
        # System monitoring (safe - interactive only)
        alias top="btop"
        alias htop="btop" 
        alias df="duf"
        alias du="dust"
        alias ps="procs"
        
        # Search replacements (interactive-only to avoid regex differences)
        if [[ -t 1 ]]; then
          alias grep="rg"
        fi
        alias find="fd"
        
        # Network tool replacements (safe)
        alias dig="dog"
        alias ping="gping"
        
        # Git replacements (safe - only affects display)
        alias diff="delta"
      fi
      
      # Alternative tools (always available, no conflicts)
      alias ls2="lsd"
      alias tree2="broot" 
      alias fzf2="sk"
      alias history2="mcfly search"
      alias tmux2="zellij"
      alias vim2="helix"
      alias top2="bottom"
      alias http2="httpie"
      alias http3="curlie"
      alias git2="gitui"
      alias tldr2="tldr"
      
      # Helpful shortcuts for modern tools (no conflicts)
      alias hex="hexyl"
      alias regex="grex"
      alias bench="hyperfine"
      alias watch2="watchexec"
      alias json="jq"
      alias yaml="yq"
      alias colorpicker="pastel"
      alias codeimg="silicon"
      alias netmon="bandwhich"
      
      # Tool selection helpers
      preferred_top() {
        case "''${PREFERRED_TOP:-btop}" in
          btop) command btop "$@" ;;
          bottom) command bottom "$@" ;;
          htop) command htop "$@" ;;
          *) command btop "$@" ;;
        esac
      }
      
      preferred_hist() {
        case "''${HIST_TOOL:-atuin}" in
          atuin) command atuin "$@" ;;
          mcfly) command mcfly "$@" ;;
          *) command atuin "$@" ;;
        esac
      }
    '';
  };
} 