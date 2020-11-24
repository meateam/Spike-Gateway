#!/bin/bash

export ROOT_PATH=/home/spike
docker stack deploy --compose-file docker-compose.yml --with-registry-auth prod
