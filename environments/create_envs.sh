#!/bin/bash

# Function to check if a conda environment exists and update or create it
manage_conda_env() {
    local env_name=$1
    local yaml_file=$2

    # Try to activate the environment
    if conda activate "$env_name" 2>/dev/null; then
        echo "Updating conda environment: $env_name"
        mamba env update -f "$yaml_file"
        conda deactivate
    else
        echo "Creating conda environment: $env_name"
        mamba env create -f "$yaml_file"
    fi
}

# Manage the NIH_env environment
manage_conda_env "NIH_env" "main_python_env.yaml"

# Manage the NIH_R_env environment
manage_conda_env "NIH_R_env" "main_R_env.yaml"
