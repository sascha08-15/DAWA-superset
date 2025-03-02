#!/bin/bash
docker compose down --rmi all
git stash
git pull
docker compose up -d