#!/bin/bash

REPO=$REPO
TOKEN=$TOKEN

cd /home/docker/actions-runner

./config.sh --url https://github.com/${REPO} --token ${TOKEN}

cleanup() {
    echo "Removing runner..."
    ./config.sh remove --unattended --token ${TOKEN}
}
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
