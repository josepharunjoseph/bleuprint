# Modern Python Development Stack
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Python interpreters
    python312        # https://docs.python.org/3.12/ - Latest stable Python
    python313        # https://docs.python.org/3.13/ - Bleeding edge Python
    
    # Modern Python package management
    uv               # https://github.com/astral-sh/uv - Ultra-fast Python package installer
    pipx             # https://github.com/pypa/pipx - Install Python apps in isolated environments
    
    # Code formatting & linting
    ruff             # https://github.com/astral-sh/ruff - Extremely fast Python linter/formatter
    black            # https://github.com/psf/black - Uncompromising code formatter
    isort            # https://github.com/PyCQA/isort - Import sorting
    
    # Type checking & analysis
    mypy             # https://github.com/python/mypy - Static type checker
    pyright          # https://github.com/microsoft/pyright - Fast type checker (LSP)
    
    # Testing & debugging
    python312Packages.pytest         # https://docs.pytest.org/ - Testing framework
    python312Packages.ipython        # https://ipython.org/ - Enhanced interactive Python
    python312Packages.ipdb           # https://github.com/gotcha/ipdb - IPython debugger
    
    # Development tools
    poetry           # https://python-poetry.org/ - Dependency management
    python312Packages.virtualenv     # https://virtualenv.pypa.io/ - Virtual environments
    python312Packages.tox            # https://tox.wiki/ - Testing across Python versions
    
    # Documentation
    python312Packages.sphinx         # https://www.sphinx-doc.org/ - Documentation generator
    
    # Performance & profiling
    # py-spy is currently marked as broken in nixpkgs
    
    # Jupyter ecosystem (optional - can be moved to separate module)
    python312Packages.jupyter      # Interactive notebooks
    python312Packages.jupyterlab   # Modern Jupyter interface
    python312Packages.notebook     # Classic Jupyter notebook
  ];
  
  # Python environment configuration
  environment.variables = {
    # Use uv for faster package installs
    PIP_REQUIRE_VIRTUALENV = "true";  # Prevent global pip installs
    PYTHONDONTWRITEBYTECODE = "1";    # Don't create .pyc files
    PYTHONUNBUFFERED = "1";           # Unbuffered output
    
    # Ruff configuration
    RUFF_CACHE_DIR = "$HOME/.cache/ruff";
  };
  
  # Shell aliases for Python development
  environment.shellAliases = {
    # Modern Python tools
    pip = "uv pip";                   # Use uv instead of pip
    python = "python3";               # Always use Python 3
    py = "python3";                   # Short alias
    
    # Virtual environments
    venv = "python -m venv";          # Create virtual environment
    activate = "source venv/bin/activate";  # Activate venv
    
    # Code quality
    py-lint = "ruff check";           # Lint with ruff
    py-format = "ruff format";        # Format with ruff
    typecheck = "mypy";               # Type checking
    
    # Testing
    py-test = "pytest";               # Run tests
    py-testv = "pytest -v";           # Verbose tests
    py-testcov = "pytest --cov";      # Coverage testing
    
    # Jupyter
    lab = "jupyter lab";              # Start JupyterLab
    notebook = "jupyter notebook";    # Start classic notebook
  };
} 