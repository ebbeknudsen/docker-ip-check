#!/bin/bash

TAG_ARGUMENT=$1
TAG="${TAG_ARGUMENT:-dev}"

docker build -t ip-check:$TAG . --network=host