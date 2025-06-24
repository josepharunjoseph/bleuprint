# Modern Rust Development Stack  
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Rust toolchain
    rustc            # https://doc.rust-lang.org/rustc/ - Rust compiler
    cargo            # https://doc.rust-lang.org/cargo/ - Rust package manager
    rustfmt          # https://github.com/rust-lang/rustfmt - Code formatter
    clippy           # https://github.com/rust-lang/rust-clippy - Linter
    rust-analyzer    # https://rust-analyzer.github.io/ - LSP server
    
    # Development tools
    cargo-watch      # https://github.com/watchexec/cargo-watch - Auto-rebuild on changes
    cargo-edit       # https://github.com/killercup/cargo-edit - Add/remove dependencies
    cargo-expand     # https://github.com/dtolnay/cargo-expand - Expand macros
    cargo-outdated   # https://github.com/kbknapp/cargo-outdated - Check for outdated deps
    cargo-audit      # https://github.com/RustSec/rustsec/tree/main/cargo-audit - Security audit
    cargo-deny       # https://github.com/EmbarkStudios/cargo-deny - Dependency management
    cargo-machete    # https://github.com/bnjbvr/cargo-machete - Remove unused dependencies
    
    # Testing & benchmarking
    cargo-nextest    # https://nexte.st/ - Fast test runner
    cargo-tarpaulin  # https://github.com/xd009642/tarpaulin - Code coverage
    criterion        # https://github.com/bheisler/criterion.rs - Benchmarking (via cargo)
    
    # Cross-compilation & targets
    cargo-cross      # https://github.com/cross-rs/cross - Cross compilation
    
    # Documentation & publishing
    mdbook           # https://rust-lang.github.io/mdBook/ - Documentation tool
    cargo-release    # https://github.com/crate-ci/cargo-release - Release automation
    
    # Performance & debugging
    cargo-flamegraph # https://github.com/flamegraph-rs/flamegraph - Profiling
    cargo-bloat      # https://github.com/RazrFalcon/cargo-bloat - Binary size analysis
    
    # Utility tools written in Rust (enhance development experience)
    ripgrep          # https://github.com/BurntSushi/ripgrep - Fast grep replacement
    fd               # https://github.com/sharkdp/fd - Fast find replacement  
    bat              # https://github.com/sharkdp/bat - Cat with syntax highlighting
    eza              # https://github.com/eza-community/eza - Modern ls replacement
    tokei            # https://github.com/XAMPPRocky/tokei - Count lines of code
    hyperfine        # https://github.com/sharkdp/hyperfine - Benchmarking tool
    dust             # https://github.com/bootandy/dust - du replacement
    procs            # https://github.com/dalance/procs - ps replacement
    bottom           # https://github.com/ClementTsang/bottom - top/htop replacement
  ];
  
  # Rust environment configuration
  environment.variables = {
    # Rust configuration
    RUST_BACKTRACE = "1";                    # Always show backtraces
    CARGO_INCREMENTAL = "1";                 # Enable incremental compilation
    RUST_LOG = "info";                       # Default log level
    
    # Cargo configuration
    CARGO_NET_GIT_FETCH_WITH_CLI = "true";   # Use git CLI for fetching
    CARGO_REGISTRIES_CRATES_IO_PROTOCOL = "sparse";  # Use sparse registry protocol
    
    # Performance optimizations
    CARGO_BUILD_JOBS = "8";                  # Parallel build jobs
    RUSTC_WRAPPER = "sccache";               # Use sccache if available (optional)
  };
  
  # Shell aliases for Rust development
  environment.shellAliases = {
    # Cargo shortcuts
    c = "cargo";
    cb = "cargo build";
    cbr = "cargo build --release";
    cr = "cargo run";
    crr = "cargo run --release";
    ct = "cargo test";
    cc = "cargo check";
    cf = "cargo fmt";
    cl = "cargo clippy";
    cla = "cargo clippy -- -W clippy::all";
    
    # Development workflow
    cw = "cargo watch -x check";             # Watch and check
    cwr = "cargo watch -x run";              # Watch and run
    cwt = "cargo watch -x test";             # Watch and test
    
    # Dependencies
    cadd = "cargo add";                      # Add dependency
    crm = "cargo rm";                        # Remove dependency
    cupgrade = "cargo upgrade";              # Upgrade dependencies
    coutdated = "cargo outdated";            # Check outdated deps
    
    # Quality & security
    caudit = "cargo audit";                  # Security audit
    cdeny = "cargo deny check";              # Check deny rules
    cmachete = "cargo machete";              # Find unused deps
    
    # Testing & coverage
    cnextest = "cargo nextest run";          # Fast test runner
    ccov = "cargo tarpaulin --html";         # Generate coverage report
    
    # Documentation
    cdoc = "cargo doc --open";               # Generate and open docs
    
    # Release
    crelease = "cargo release";              # Release automation
    
    # Analysis
    cbloat = "cargo bloat --release";        # Analyze binary size
    cflame = "cargo flamegraph";             # Generate flamegraph
  };
} 