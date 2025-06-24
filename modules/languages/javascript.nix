# Modern JavaScript/TypeScript Development Stack
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Node.js ecosystem
    nodejs_20        # https://nodejs.org/docs/latest-v20.x/api/ - LTS Node.js
    nodejs_22        # https://nodejs.org/docs/latest-v22.x/api/ - Latest Node.js
    
    # Package managers
    npm              # https://docs.npmjs.com/ - Default package manager
    yarn             # https://yarnpkg.com/ - Alternative package manager
    pnpm             # https://pnpm.io/ - Fast, disk space efficient package manager
    
    # Modern development tools
    typescript       # https://www.typescriptlang.org/ - TypeScript compiler
    tsx              # https://github.com/esbuild-kit/tsx - TypeScript execution
    ts-node          # https://typestrong.org/ts-node/ - TypeScript execution
    
    # Linting & formatting
    eslint           # https://eslint.org/ - JavaScript linter
    prettier         # https://prettier.io/ - Code formatter
    
    # Build tools & bundlers
    vite             # https://vitejs.dev/ - Fast build tool
    webpack          # https://webpack.js.org/ - Module bundler
    esbuild          # https://esbuild.github.io/ - Extremely fast bundler
    rollup           # https://rollupjs.org/ - Module bundler
    
    # Testing frameworks
    vitest           # https://vitest.dev/ - Fast unit test framework
    playwright       # https://playwright.dev/ - E2E testing
    
    # Development servers & tools
    nodemon          # https://nodemon.io/ - Auto-restart on changes
    concurrently     # https://github.com/open-cli-tools/concurrently - Run commands concurrently
    
    # Package management utilities
    npm-check-updates # https://github.com/raineorshine/npm-check-updates - Update dependencies
    depcheck         # https://github.com/depcheck/depcheck - Find unused dependencies
    
    # Documentation
    typedoc          # https://typedoc.org/ - TypeScript documentation generator
    
    # Performance & analysis
    clinic           # https://clinicjs.org/ - Performance profiling
    
    # React/Vue development (optional - can be separate modules)
    nodePackages.create-react-app     # React app generator
    nodePackages."@vue/cli"           # Vue CLI
  ];
  
  # JavaScript/Node.js environment configuration
  environment.variables = {
    # Node.js configuration
    NODE_ENV = "development";          # Default to development
    NODE_OPTIONS = "--max-old-space-size=4096";  # Increase memory limit
    
    # npm configuration
    NPM_CONFIG_PROGRESS = "false";     # Disable progress bar for cleaner output
    NPM_CONFIG_AUDIT = "false";        # Disable automatic audit (can be slow)
    
    # TypeScript configuration
    TS_NODE_COMPILER_OPTIONS = "{\"module\":\"commonjs\"}";
  };
  
  # Shell aliases for JavaScript/TypeScript development
  environment.shellAliases = {
    # Node.js shortcuts
    node20 = "node";                   # Default to Node 20 LTS
    node22 = "${pkgs.nodejs_22}/bin/node";  # Latest Node.js
    
    # Package managers
    ni = "npm install";
    nid = "npm install --save-dev";
    nig = "npm install --global";
    nu = "npm uninstall";
    nr = "npm run";
    ns = "npm start";
    nt = "npm test";
    nb = "npm run build";
    
    # Yarn shortcuts
    yi = "yarn install";
    ya = "yarn add";
    yad = "yarn add --dev";
    yr = "yarn run";
    ys = "yarn start";
    yt = "yarn test";
    yb = "yarn build";
    
    # pnpm shortcuts
    pi = "pnpm install";
    pa = "pnpm add";
    pad = "pnpm add --save-dev";
    pr = "pnpm run";
    ps = "pnpm start";
    pt = "pnpm test";
    pb = "pnpm build";
    
    # TypeScript
    tsc = "npx tsc";                   # TypeScript compiler
    tsw = "npx tsc --watch";           # Watch mode
    tsx-run = "npx tsx";               # Run TypeScript directly
    
    # Development tools
    lint = "npx eslint";               # Lint JavaScript/TypeScript
    format = "npx prettier --write";   # Format code
    dev = "npm run dev";               # Start dev server
    serve = "npx serve";               # Serve static files
    
    # Testing
    vitest = "npx vitest";             # Run Vitest
    playwright = "npx playwright";     # Run Playwright tests
    
    # Utilities
    ncu = "npx npm-check-updates";     # Check for updates
    depcheck = "npx depcheck";         # Check for unused deps
    
    # Create new projects
    create-react = "npx create-react-app";
    create-vue = "npx @vue/create";
    create-vite = "npx create-vite";
    create-next = "npx create-next-app";
  };
} 