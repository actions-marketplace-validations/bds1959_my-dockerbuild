FROM python:3.8-slim-buster

# Install the toolset.
RUN apt -y update && apt -y install curl \
    && apt install docker.io -y
#FROM docker:stable

LABEL "name"="my-Dockerbuild"
LABEL "maintainer"="murali"
LABEL "version"="1.0"

LABEL "com.github.actions.icon"="upload-cloud"
LABEL "com.github.actions.color"="blue"
LABEL "com.github.actions.name"="my-Dockerbuild"
LABEL "com.github.actions.description"="Login, Build Image, Tag and Push images to any registry"
COPY README.md /

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
