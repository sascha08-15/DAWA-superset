#!/bin/bash
docker compose down --rmi all --volumes
git stash
git pull
docker compose up -d