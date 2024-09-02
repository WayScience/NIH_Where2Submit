#!/bin/bash

# This script will call the other scripts

# # create the environments
cd environments
source create_envs.sh
cd ../

# Download the data
conda activate NIH_env
cd 0.download_data
jupyter nbconvert --to=script --FilesWriter.build_directory=scripts/ notebooks/*.ipynb
cd scripts
python 0.download_data.py

# Clean the data
cd ../../1.clean_data
jupyter nbconvert --to=script --FilesWriter.build_directory=scripts/ notebooks/*.ipynb
cd scripts
python 0.clean_data.py
cd ../../

# Deploy the RShiny app

cd 2.deploy_RShiny
jupyter nbconvert --to=script --FilesWriter.build_directory=scripts/ notebooks/*.ipynb
conda deactivate
conda activate NIH_R_env
cd scripts
RScript 1.deploy_shiny_app.r
cd ../../
conda deactivate


echo "All scripts have been executed"
