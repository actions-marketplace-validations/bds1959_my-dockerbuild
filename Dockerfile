FROM python:3.8-slim-buster

RUN apt -y update && apt -y install curl \
    && apt install docker.io -y

RUN apt -y update && apt -y install curl \
    && pip install awscli \
    && curl https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
    && curl -LO https://storage.googleapis.com/kubernetes-release/release/v1.19.0/bin/linux/amd64/kubectl \

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
