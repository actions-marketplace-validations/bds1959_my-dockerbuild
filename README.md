# Docker Login Build Tag Push

GitHub action to build, tag and push images to Registry.
You can use this image with currently `docker.io` or any of Google Cloud Registries like `gcr.io`.

Configuration takes two inputs and environmental variable configurations of  your repository.

Below are some examples. This action will be published when fully polished.

## Examples

Here are examples of workflows that use this action on only push to master.

### Push to Google Cloud Registry eg gcr.io

### Pus to docker hub

```yml
name: dockerbuild
on: 
  push:
      branches:    
          - master
          - develop
jobs:

  build_push_docker_image:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v1

    - name: Build and Push
      uses: bds1959/my-Dockerbuild@v2.0
      env:
        DOCKER_USERNAME: "docker_user_name"
        DOCKER_NAMESPACE: "docker_name_space"
        DOCKER_PASSWORD: ${{ secrets.DOCKER_PASSWORD }}
        REGISTRY_URL: "docker.io"
      with:
       image_name: "my-image"
       image_tag: "latest"
```

## TODO

- Add login to `docker.pkg.github.com`
