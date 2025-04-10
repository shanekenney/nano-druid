#!/bin/bash
if [ $# -ne 1 ]; then
    echo "Usage: $0 <version>"
    exit 1
fi

VERSION=$1

docker buildx build \
    --platform linux/arm64/v8,linux/amd64 \
    --build-arg VERSION=${VERSION} \
    --tag shanek/nano-druid:${VERSION} .
