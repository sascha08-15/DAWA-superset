#!/bin/bash
docker compose down --rmi all --volumes
docker volume prune -f
git stash
git pull
docker compose up -d