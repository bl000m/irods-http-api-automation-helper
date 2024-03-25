#!/bin/bash

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is not installed or not in PATH. Please install Docker before running this script."
    exit 1
fi

# Check if Docker daemon is running
if ! docker info &> /dev/null; then
    echo "Error: Docker daemon is not running. Please start Docker before running this script."
    exit 1
fi

# Clone iRODS HTTP API repository if not already cloned
if [ ! -d "irods_http_api" ]; then
    git clone https://github.com/irods/irods_client_http_api.git irods_http_api || { echo "Error: Failed to clone iRODS HTTP API repository."; exit 1; }
fi

# Move config file to the cloned directory
mv ./config.json irods_http_api || { echo "Error: Failed to move config file to iRODS HTTP API directory."; exit 1; }

# Change directory to iRODS HTTP API directory
cd irods_http_api || { echo "Error: Failed to change directory to iRODS HTTP API directory."; exit 1; }

# Create packages directory if not exists
mkdir -p packages || { echo "Error: Failed to create packages directory."; exit 1; }

# Clone genquery2 repository if not already cloned
if [ ! -d "genquery2/.git" ]; then
    git clone https://github.com/irods/irods_api_plugin_genquery2.git genquery2 || { echo "Error: Failed to clone genquery2 repository."; exit 1; }
else
    echo "genquery2 repository already exists."
fi

# Build iRODS HTTP API builder Docker image
docker build -t irods-http-api-builder -f irods_builder.Dockerfile . || { echo "Error: Failed to build iRODS HTTP API builder Docker image."; exit 1; }

# Run iRODS HTTP API builder Docker container
docker run -it --rm \
    -v ./genquery2:/genquery2_source:ro \
    -v .:/http_api_source:ro \
    -v ./packages:/packages_output \
    irods-http-api-builder || { echo "Error: Failed to run iRODS HTTP API builder Docker container."; exit 1; }

# Count the number of DEB packages generated
deb_count=$(find packages -type f -name "*.deb" | wc -l)
if [ "$deb_count" -ne 2 ]; then
    echo "Error: Expected 2 DEB packages but found $deb_count."
    exit 1
fi

# Build iRODS HTTP API runner Docker image
docker build -t irods-http-api-runner \
    -f irods_runner.Dockerfile \
    ./packages || { echo "Error: Failed to build iRODS HTTP API runner Docker image."; exit 1; }

echo "Checking version installed:"
# Run iRODS HTTP API runner Docker container to display installed version
docker run -it --rm irods-http-api-runner -v || { echo "Error: Failed to run iRODS HTTP API runner Docker container."; exit 1; }

# Run iRODS HTTP API Docker container
docker run -d --rm --name irods_http_api \
    -v ./config.json:/config.json:ro \
    -p 9000:9000 \
    irods-http-api-runner || { echo "Error: Failed to run iRODS HTTP API Docker container."; exit 1; }
