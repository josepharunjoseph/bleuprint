# Modern Go Development Stack
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Go toolchain
    go               # https://go.dev/doc/ - Go programming language
    gopls            # https://pkg.go.dev/golang.org/x/tools/gopls - Go language server
    
    # Development tools
    golangci-lint    # https://golangci-lint.run/ - Fast linters runner
    gofumpt          # https://github.com/mvdan/gofumpt - Stricter gofmt
    gotools          # https://pkg.go.dev/golang.org/x/tools - Additional Go tools (includes goimports)
    
    # Testing & coverage
    gotestsum        # https://github.com/gotestyourself/gotestsum - Enhanced go test
    # go-junit-report  # Check if available
    
    # Debugging & profiling
    delve            # https://github.com/go-delve/delve - Go debugger
    
    # Documentation
    # godoc            # Check if available (might be in gotools)
    
    # Dependency management
    # go-mod-outdated  # Check if available
    
    # Code generation
    # stringer         # Check if available (might be in gotools)
    
    # Popular Go tools
    air              # https://github.com/cosmtrek/air - Live reload for Go apps
    goreleaser       # https://goreleaser.com/ - Release automation
    
    # Web development
    # templ            # Check if available
  ];
  
  # Go environment configuration
  environment.variables = {
    # Go configuration
    GOPROXY = "https://proxy.golang.org,direct";  # Go module proxy
    GOSUMDB = "sum.golang.org";                   # Go checksum database
    GOPRIVATE = "";                               # Private module patterns
    GONOPROXY = "";                               # Modules to not proxy
    GONOSUMDB = "";                               # Modules to not checksum
    
    # Development settings
    CGO_ENABLED = "1";                            # Enable CGO by default
    GO111MODULE = "on";                           # Always use modules
    
    # Performance
    GOMAXPROCS = "8";                             # Max CPU cores to use
  };
  
  # Shell aliases for Go development
  environment.shellAliases = {
    # Go commands
    # Note: We intentionally avoid using the single-letter alias `g` because it
    # conflicts with the global Git alias defined in `modules/system/dev-tools.nix`.
    # Prefer the explicit `go` command or the more descriptive aliases below.
    gb = "go build";
    gbr = "go build -race";                       # Build with race detector
    gr = "go run";
    grr = "go run -race";                         # Run with race detector
    gt = "go test";
    gtv = "go test -v";                           # Verbose tests
    gtr = "go test -race";                        # Test with race detector
    gtc = "go test -cover";                       # Test with coverage
    gtb = "go test -bench=.";                     # Run benchmarks
    
    # Module management
    gmi = "go mod init";                          # Initialize module
    gmt = "go mod tidy";                          # Clean up module
    gmv = "go mod verify";                        # Verify module
    gmd = "go mod download";                      # Download dependencies
    
    # Code quality
    gf = "gofmt -w";                              # Format code
    gfu = "gofumpt -w";                           # Format with gofumpt
    gi = "goimports -w";                          # Fix imports (from gotools)
    glint = "golangci-lint run";                  # Run linters
    
    # Documentation
    gdoc = "go doc";                              # Show documentation
    
    # Development workflow
    gw = "air";                                   # Live reload
    grel = "goreleaser";                          # Release automation
    
    # Testing utilities
    gts = "gotestsum";                            # Enhanced test runner
    # gtj = "go test -json | go-junit-report";      # JUnit format (if available)
    
    # Debugging
    gdlv = "dlv debug";                           # Debug current package
    
    # Information
    gv = "go version";                            # Go version
    ge = "go env";                                # Go environment
    gls = "go list -m all";                       # List all modules
    
    # Outdated dependencies (manual check for now)
    # goutdated = "go-mod-outdated -update -direct"; # Check outdated deps
  };
} 