# iRODS HTTP API Setup and Launch

This project aims to provide a humble contribution by simplifying the setup and launch process of the iRODS HTTP API, currently at version 0.3.0, to run iRODS as an OAuth-protected resource. It is meant to facilitate developers testing the iRODS HTTP API in development mode to help better the iRODS team by providing feedback. This approach allows for a more comprehensive understanding and testing of the API compared to solely pulling the Docker image, which can lead to errors or misunderstandings of bugs. Please note that the configuration provided in this project is intended for testing purposes only and is not secure, as it operates over HTTP rather than HTTPS.

## This project include 
- a script that aims to simplify the setup and launch process of the iRODS HTTP API, currently at version 0.3.0, 
- a config.json file that has been tested for enabling integration with OAuth authentication mechanisms.

## Script features:

- Automates the setup and launch of the iRODS HTTP API.
- Clones the necessary repositories and sets up the configuration files.
- Builds Docker images for the iRODS HTTP API builder and runner.
- Handles dependencies and error conditions.

## Usage:

- Clone this repository to your local machine.
- update the config.json
- Run the provided script, which automates the setup and launch process of the iRODS HTTP API.



## Requirements:

- Docker installed and running on your system.
