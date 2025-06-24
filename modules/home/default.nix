{ pkgs, ... }:

{
  imports = [
    ./aliases.nix
  ];
  
  home.stateVersion = "24.05";
  
  # Enable modern tool replacements (set to true to replace traditional commands)
  programs.modernTools.enable = true;
  
  # Shell configuration
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    
    shellAliases = {
      # Basic aliases that don't conflict with modernTools
      # Editor
      vim = "nvim";
      vi = "nvim";
      
      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git log --oneline --graph";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      
      # Development
      dc = "docker compose";
      k = "kubectl";
      tf = "terraform";
      py = "python3";
      
      # Quick navigation
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
      
      # Safety aliases
      rm = "rm -i";
      cp = "cp -i";
      mv = "mv -i";
      
      # Convenience
      h = "history";
      j = "jobs";
      which = "type -a";
      
      # If modernTools is disabled, provide basic modern tool shortcuts
      # These won't conflict since they use different names
      e = "eza";
      b = "bat";
      f = "fd";
    };
    
    initContent = ''
      # FZF integration
      source ${pkgs.fzf}/share/fzf/key-bindings.zsh
      source ${pkgs.fzf}/share/fzf/completion.zsh
      
      # Better history
      setopt SHARE_HISTORY
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_FIND_NO_DUPS
      
      # Zoxide (better cd)
      eval "$(${pkgs.zoxide}/bin/zoxide init zsh)"
      
      # Atuin (better history)
      eval "$(${pkgs.atuin}/bin/atuin init zsh)"
    '';
  };

  # Git configuration
  programs.git = {
    enable = true;
    userName = "Test User";  # TODO: Update this
    userEmail = "test@example.com";  # TODO: Update this
    
    delta = {
      enable = true;
      options = {
        navigate = true;
        light = false;
        line-numbers = true;
        side-by-side = true;
      };
    };
    
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.colorMoved = "default";
      
      # Better diff algorithm
      diff.algorithm = "histogram";
      
      # Signing commits (optional)
      # commit.gpgsign = true;
      # user.signingkey = "YOUR_GPG_KEY";
    };
    
    aliases = {
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitui";
    };
  };

  # Starship prompt
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";
      
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };
      
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      
      git_branch = {
        format = "[$symbol$branch]($style) ";
      };
      
      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
      };
      
      nodejs = {
        format = "[$symbol($version )]($style)";
      };
      
      python = {
        format = "[$symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)";
      };
      
      rust = {
        format = "[$symbol($version )]($style)";
      };
      
      golang = {
        format = "[$symbol($version )]($style)";
      };
    };
  };

  # Direnv for project environments
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };

  # Tmux configuration
  programs.tmux = {
    enable = true;
    terminal = "screen-256color";
    historyLimit = 10000;
    keyMode = "vi";
    
    extraConfig = ''
      # Better prefix key
      unbind C-b
      set -g prefix C-a
      bind C-a send-prefix
      
      # Split panes with | and -
      bind | split-window -h
      bind - split-window -v
      
      # Reload config
      bind r source-file ~/.tmux.conf \; display-message "Config reloaded!"
      
      # Enable mouse
      set -g mouse on
      
      # Start windows and panes at 1
      set -g base-index 1
      setw -g pane-base-index 1
    '';
  };

  # SSH configuration
  programs.ssh = {
    enable = true;
    compression = true;
    
    extraConfig = ''
      # Reuse SSH connections
      Host *
        ControlMaster auto
        ControlPath ~/.ssh/sockets/%r@%h-%p
        ControlPersist 600
    '';
  };
} 