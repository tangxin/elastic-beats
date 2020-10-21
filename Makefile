BEAT ?= filebeat
VERSION := $(shell cat .version)
DISTROLESS ?= static

build:
	bash -x buildx.sh

docker.distroless:
	docker buildx build --push --platform=linux/amd64,linux/arm64 --progress plain \
		--tag kubeimages/$(BEAT):$(VERSION)-${DISTROLESS} \
		--file Dockerfile.distroless \
		--build-arg BEAT=$(BEAT) \
		--build-arg VERSION=$(VERSION) \
		--build-arg DISTROLESS=gcr.io/distroless/$(DISTROLESS) \
		.

docker.static:
	DISTROLESS=static make docker.distroless -B

docker.cc-debug:
	DISTROLESS=cc-debug make docker.distroless -B

docker:
	docker buildx build --push --platform=linux/amd64,linux/arm64 --progress plain \
		--tag kubeimages/$(BEAT):$(VERSION) \
		--file Dockerfile \
		--build-arg=BEAT=$(BEAT) \
		--build-arg VERSION=$(VERSION) .

clean: checkout
	rm -rf out

checkout:
	cd beats && git checkout . && git checkout master

