#!/bin/bash

TAG="$1"

if [ -z "$TAG"]; then
  echo "Tag not supplied, exiting"
  exit 1
fi

echo "Building docker image ghcr.io/ebbeknudsen/ip-check with tags: $TAG and latest"
docker build -t ghcr.io/ebbeknudsen/ip-check:$TAG -t ghcr.io/ebbeknudsen/ip-check:latest .

echo "Pushing all tags to ghcr.io/ebbeknudsen/ip-check"
docker push --all-tags ghcr.io/ebbeknudsen/ip-check