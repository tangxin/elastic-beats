# elastic beats images (linux/amd64, linux/arm64)

this repo is for building elastic stack beats images with multiple cpu architecture.

# images

all images are use [google distroless image](https://github.com/GoogleContainerTools/distroless) as basic.

+ `${image}:${version}-static` is use for product enviroments.
+ `${image}:${version}-cc-debug` is use for dev enviroments or debug purpose.

## hub.docker Organizations

kubeimages:  https://hub.docker.com/orgs/kubeimages/repositories


# notice

all images' tag are without `v`