#!/bin/bash
git pull
cd frontend/
npm install
npm run build
cd ..
docker-compose build
