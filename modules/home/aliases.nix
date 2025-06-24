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
    programs.zsh.shellAliases = {
      # File system replacements
      ls = "eza --icons";
      ll = "eza -l --icons";
      la = "eza -la --icons";
      lt = "eza --tree --icons";
      tree = "erd";
      
      # File content viewers
      cat = "bat";
      less = "bat --paging=always";
      
      # System monitoring replacements
      top = "btop";
      htop = "btop";
      df = "duf";
      du = "dust";
      ps = "procs";
      
      # Search replacements
      grep = "rg";
      find = "fd";
      
      # Network tool replacements
      dig = "dog";
      ping = "gping";
      
      # Git replacements
      diff = "delta";
      
      # Alternative tools (not replacing defaults)
      ls2 = "lsd";
      tree2 = "broot";
      fzf2 = "sk";
      history2 = "mcfly search";
      tmux2 = "zellij";
      vim2 = "helix";
      
      # Helpful shortcuts for modern tools
      hex = "hexyl";
      regex = "grex";
      bench = "hyperfine";
      watch2 = "watchexec";
      json = "jq";
      yaml = "yq";
      colorpicker = "pastel";
      codeimg = "silicon";
      netmon = "bandwhich";
    };
  };
} 