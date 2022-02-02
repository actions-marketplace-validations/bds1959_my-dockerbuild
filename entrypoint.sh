#!/bin/sh

if [ -n "$DOCKER_PASSWORD"$ ]
  then
   echo "$DOCKER_PASSWORD" > "$HOME"/docker-login_password.text
else
  echo "Not auth credentials specified"
fi

DOCKER_REGISTRY_URL="$REGISTRY_URL"

DOCKER_IMAGE_NAME="$1"
DOCKER_IMAGE_TAG="$2"

USERNAME=${GITHUB_REPOSITORY%%/*}
REPOSITORY=${GITHUB_REPOSITORY#*/}

REGISTRY=${DOCKER_REGISTRY_URL} 
NAMESPACE=${DOCKER_NAMESPACE:-$USERNAME}
IMAGE_NAME=${DOCKER_IMAGE_NAME:-$REPOSITORY}
IMAGE_TAG=${DOCKER_IMAGE_TAG:-$GIT_TAG}
if [ -n "$DOCKER_PASSWORD" ]
 then
  sh -c "cat "$HOME"/docker-login_password.text | docker login --username $DOCKER_USERNAME --password-stdin"
else 
  echo "Not docker authorization provided. Skipping login"
fi
sh -c "docker build -t $IMAGE_NAME ." 
REGISTRY_IMAGE="$NAMESPACE/$IMAGE_NAME"
sh -c "docker tag $IMAGE_NAME $REGISTRY_IMAGE:$DOCKER_IMAGE_TAG"
sh -c "docker push $REGISTRY_IMAGE:$IMAGE_TAG"
