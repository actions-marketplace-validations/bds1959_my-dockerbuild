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

echo "::set-output name=image_url::$REGISTRY_IMAGE:$IMAGE_TAG"

# Login to Kubernetes Cluster.
if [ -n "$CLUSTER_ROLE_ARN" ]; then
    aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME} --role-arn=${CLUSTER_ROLE_ARN}
else
    aws eks --region ${AWS_REGION} update-kubeconfig --name ${CLUSTER_NAME}
fi

# Helm Deployment
DEPS_UPDATE_COMMAND="helm dependency update ${DEPLOY_CHART_PATH}"
UPGRADE_COMMAND="helm upgrade --install --timeout ${TIMEOUT}"

if [ "$DEPLOY_ATOMIC" = "true" ]; then
    UPGRADE_COMMAND="${UPGRADE_COMMAND} --atomic"
fi

if [ "$DEPLOY_FORCE" = "true" ]; then
  UPGRADE_COMMAND="${UPGRADE_COMMAND} --force"
fi

for config_file in ${DEPLOY_CONFIG_FILES//,/ }
do
    UPGRADE_COMMAND="${UPGRADE_COMMAND} -f ${config_file}"
done
if [ -n "$DEPLOY_NAMESPACE" ]; then
    UPGRADE_COMMAND="${UPGRADE_COMMAND} -n ${DEPLOY_NAMESPACE}"
fi
if [ -n "$DEPLOY_VALUES" ]; then
    UPGRADE_COMMAND="${UPGRADE_COMMAND} --set ${DEPLOY_VALUES}"
fi
UPGRADE_COMMAND="${UPGRADE_COMMAND} ${DEPLOY_NAME} ${DEPLOY_CHART_PATH}"
echo "Executing: ${DEPS_UPDATE_COMMAND}"
${DEPS_UPDATE_COMMAND}
echo "Executing: ${UPGRADE_COMMAND}"
${UPGRADE_COMMAND}


