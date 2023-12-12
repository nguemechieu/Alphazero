#!/bin/bash

# Check if Python is already installed
if command -v python &> /dev/null; then
    echo "Python is already installed. Uninstalling previous version..."
    python -m pip uninstall -y pip setuptools
    python -m pip uninstall -y wheel
    python -m pip uninstall -y virtualenv
    python -m pip uninstall -y virtualenvwrapper

    # Uninstall Python
    python -m pip uninstall -y python
fi

# Download the latest Python installer
curl -o python-installer.exe https://www.python.org/ftp/python/latest/python-3.x.x-amd64.exe

# Run the installer with silent mode and add Python to PATH
./python-installer.exe /quiet InstallAllUsers=1 PrependPath=1

# Clean up the installer
rm python-installer.exe

# Verify the installation
python --version

# Update pip to the latest version
python -m ensurepip --upgrade
python -m pip install --upgrade pip

# Print Python and pip versions
python --version
pip --version
