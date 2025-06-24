# Modern JavaScript/TypeScript Development Stack (Bun-focused)
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Primary JavaScript runtime
    bun              # https://bun.sh/ - Ultra-fast JavaScript runtime, bundler, transpiler & package manager
    
    # Node.js ecosystem (for compatibility)
    nodejs_20        # https://nodejs.org/docs/latest-v20.x/api/ - LTS Node.js (compatibility)
    
    # Modern development tools
    typescript       # https://www.typescriptlang.org/ - TypeScript compiler
    
    # Linting & formatting
    eslint           # https://eslint.org/ - JavaScript linter
    prettier         # https://prettier.io/ - Code formatter
    
    # Build tools & bundlers (Bun has built-in bundling, these are for compatibility)
    vite             # https://vitejs.dev/ - Fast build tool
    esbuild          # https://esbuild.github.io/ - Extremely fast bundler
    
    # Development tools
    nodemon          # https://nodemon.io/ - Auto-restart on changes (for Node.js projects)
  ];
  
  # JavaScript/Bun environment configuration
  environment.variables = {
    # Bun configuration
    BUN_INSTALL = "$HOME/.bun";              # Bun installation directory
    
    # Node.js configuration (for compatibility)
    NODE_ENV = "development";                # Default to development
    NODE_OPTIONS = "--max-old-space-size=4096";  # Increase memory limit
    
    # TypeScript configuration (Bun handles this natively)
    BUN_CONFIG_NO_CLEAR_TERMINAL_ON_RELOAD = "true";  # Keep terminal output
  };
  
  # Shell aliases for Bun-focused JavaScript/TypeScript development
  environment.shellAliases = {
    # Bun primary commands
    b = "bun";                             # Main Bun command
    bi = "bun install";                    # Install dependencies
    ba = "bun add";                        # Add dependency
    bad = "bun add --dev";                 # Add dev dependency
    br = "bun run";                        # Run script
    bs = "bun start";                      # Start application
    bt = "bun test";                       # Run tests (Bun has built-in test runner)
    bb = "bun build";                      # Build project
    bx = "bunx";                           # Execute package (like npx)
    
    # Bun development workflow
    dev = "bun run dev";                   # Start dev server
    build = "bun run build";               # Build project
    preview = "bun run preview";           # Preview build
    
    # TypeScript with Bun (native support)
    tsc = "bun tsc";                       # TypeScript compiler via Bun
    tsx = "bun run";                       # Run TypeScript directly with Bun
    
    # Node.js compatibility aliases
    node = "node";                         # Node.js runtime
    npm = "echo 'Use bun instead of npm! Try: bun install, bun add, etc.'";
    yarn = "echo 'Use bun instead of yarn! Bun is faster and has better TypeScript support.'";
    pnpm = "echo 'Use bun instead of pnpm! Bun includes package management natively.'";
    
    # Development tools
    lint = "bun eslint";                   # Lint with ESLint via Bun
    format = "bun prettier --write";       # Format code with Prettier via Bun
    serve = "bun serve";                   # Serve static files with Bun
    
    # Testing (Bun has built-in test runner)
    test = "bun test";                     # Run tests with Bun
    test-watch = "bun test --watch";       # Watch mode testing
    
    # Create new projects (Bun equivalents)
    create-bun = "bun create";             # Create new Bun project
    create-react = "bun create react";     # Create React app with Bun
    create-vue = "bun create vue";         # Create Vue app with Bun
    create-vite = "bun create vite";       # Create Vite project with Bun
    create-next = "bun create next-app";   # Create Next.js app with Bun
    
    # Package management
    outdated = "bun outdated";             # Check for outdated packages
    upgrade = "bun update";                # Update all packages
    
    # Bun-specific utilities
    bun-upgrade = "bun upgrade";           # Upgrade Bun itself
    bun-completions = "bun completions";   # Generate shell completions
  };
} 