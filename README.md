# elastic beats images (linux/amd64, linux/arm64)

this repo is for building elastic stack beats images with multiple cpu architecture.

# images

1. common image `${image}:${version}` are using [debian:buster-slim](https://hub.docker.com/_/debian?tab=tags&page=1&name=buster-slim) as basic image.
2. runtime images `${image}:${version}-static` are using [google distroless image](https://github.com/GoogleContainerTools/distroless) as basic image. suggest to use it in product


## hub.docker Organizations

kubeimages:  https://hub.docker.com/orgs/kubeimages/repositories

+ `kubeimages/filebeat:7.9.3`, `kubeimages/filebeat:7.9.3-static`


# notice

all images' tag are without `v`
