BEAT ?= filebeat
VERSION := $(shell cat .version)


build:
	bash -x buildx.sh

docker.distroless:
	docker buildx build --push --platform=linux/amd64,linux/arm64 --progress plain \
		--tag kubeimages/$(BEAT):$(VERSION)-distroless \
		--file Dockerfile.distroless \
		--build-arg=BEAT=$(BEAT) \
		--build-arg VERSION=$(VERSION) .
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
