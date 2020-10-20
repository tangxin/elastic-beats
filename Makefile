BEAT ?= filebeat
VERSION := $(shell cat .version)

build-docker:
	docker buildx build --push --platform=linux/amd64,linux/arm64 --progress plain \
		--tag kubeimages/$(BEAT):$(VERSION) \
		--file Dockerfile \
		--build-arg=BEAT=$(BEAT) \
		--build-arg VERSION=$(VERSION) .
