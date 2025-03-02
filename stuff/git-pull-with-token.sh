#! /bin/bash

GH_USER="<your_username>"
GH_TOKEN="<your_token>"
REPO_NAME="<your_repository_name>"

git pull https://$GH_USER:$GH_TOKEN@github.com/$GH_USER/$REPO_NAMW.git
