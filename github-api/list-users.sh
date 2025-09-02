#!/bin/bash

#########
#About : This script when executed shows the thes list of users who have access to this repo
# Input: export username="username"
#Input : export GITHUB_TOKEN=token
#Owner:Shalin K
#########



# GitHub API URL
API_URL="https://api.github.com"

# Use the environment variable GITHUB_TOKEN (already exported)
# You don’t need USERNAME/PASSWORD anymore
TOKEN=$GITHUB_TOKEN

# User and Repository information
REPO_OWNER=$1
REPO_NAME=$2

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -H "Authorization: token $TOKEN" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint")"
    
    # Display the list of collaborators
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators" | jq -r '.[] | "\(.login) → role: \(.role_name)"'
    fi
}

function helper {
    expected_cmd_args=2
    if [ $# -ne $expected_cmd_args ]; then
        echo "Please invoke the script with required cmd args"
        echo "Usage: ./list-users.sh <repo_owner> <repo_name>"
        exit 1
    fi
}


# Main script
helper "$@"
echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access

