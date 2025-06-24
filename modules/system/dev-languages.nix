{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core development languages
    git          # https://git-scm.com/doc
    go           # https://go.dev/doc/
    rustc        # https://doc.rust-lang.org/rustc/
    cargo        # https://doc.rust-lang.org/cargo/
    python312    # https://docs.python.org/3.12/
    nodejs_20    # https://nodejs.org/docs/latest-v20.x/api/
    
    # Build tools
    cmake        # https://cmake.org/documentation/
    gnumake      # https://www.gnu.org/software/make/manual/
    just         # https://github.com/casey/just - Modern make alternative
    
    # Basic network tools (needed for development)
    curl         # https://curl.se/docs/
    wget         # https://www.gnu.org/software/wget/manual/
  ];
} 