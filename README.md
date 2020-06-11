# LoadAllPackages.jl loads all packages

[![Build Status](https://github.com/tkf/LoadAllPackages.jl/workflows/CI/badge.svg)](https://github.com/tkf/LoadAllPackages.jl/actions)

Usage:

* `LoadAllPackages.loadall()`: Load all packages installed in the
  current project.
* `LoadAllPackages.loadall("/PATH/TO/Project.toml")`: Load all
  packages installed in `/PATH/TO/Project.toml`.
* `LoadAllPackages.@loadall("PATH/TO/Project.toml")` Load all packages
  installed in `joinpath(@__DIR__, "PATH/TO/Project.toml")`.
