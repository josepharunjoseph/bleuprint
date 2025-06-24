# Optional ML/Data Science Stack
# Uncomment the import in flake.nix to enable
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Python ML packages
    python313Packages.pytorch      # https://pytorch.org/ - Deep learning framework
    python313Packages.torchvision  # Computer vision for PyTorch
    #python313Packages.tensorflow   # https://tensorflow.org/ - ML framework
    python313Packages.scikit-learn # https://scikit-learn.org/ - ML library
    python313Packages.pandas       # https://pandas.pydata.org/ - Data analysis
    python313Packages.numpy        # https://numpy.org/ - Numerical computing
    python313Packages.matplotlib   # https://matplotlib.org/ - Plotting
    python313Packages.jupyter      # https://jupyter.org/ - Interactive notebooks
    python313Packages.ipython      # Enhanced Python shell
    
    # Data processing tools
    # apache-spark not available in nixpkgs
    duckdb        # https://duckdb.org/ - In-process SQL OLAP
    # polars        # Check if available
    
    # Visualization
    # plotly        # Check if available
    
    # GPU tools (for Apple Silicon)
    # Note: Metal performance shaders are included with macOS
  ];
  
  # Environment variables for ML frameworks
  environment.variables = {
    # Use Metal Performance Shaders on Apple Silicon
    PYTORCH_ENABLE_MPS_FALLBACK = "1";
    # TensorFlow Metal plugin is auto-detected
  };
} 