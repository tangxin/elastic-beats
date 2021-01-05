BEAT ?= filebeat
VERSION := $(shell cat .version)
DISTROLESS ?= static
BEATs ?= $(shell ls beats/ |grep beat)

build: checkout.version
	bash -x buildx.sh

docker.prepare:
	rm -f $(BEAT).Dockerfile.distroless && \
	cp -a Dockerfile.distroless.tpl $(BEAT).Dockerfile.distroless && \
	sed -i 's/{{ BEAT }}/$(BEAT)/g' $(BEAT).Dockerfile.distroless

docker.debian:
	docker buildx build --push --platform=linux/amd64,linux/arm64 --progress plain \
		--tag kubeimages/$(BEAT):$(VERSION) \
		--file Dockerfile \
		--build-arg BEAT=$(BEAT) \
		--build-arg VERSION=$(VERSION) \
		.

docker.distroless: docker.prepare
	docker buildx build --push --platform=linux/amd64,linux/arm64 --progress plain \
		--tag kubeimages/$(BEAT):$(VERSION)-$(subst :,-,$(DISTROLESS)) \
		--file $(BEAT).Dockerfile.distroless \
		--build-arg BEAT=$(BEAT) \
		--build-arg VERSION=$(VERSION) \
		--build-arg DISTROLESS=gcr.io/distroless/$(DISTROLESS) \
		.

docker.static:
	DISTROLESS=static BEAT=$(BEAT) make docker.distroless -B

docker.cc-debug:
	DISTROLESS=cc:debug BEAT=$(BEAT) make docker.distroless -B

docker.echo:
	echo docker buildx $(BEAT)

docker.all: build
	#  make 后面的分号 很重要， 没有则不会判定为可执行语句
	$(foreach beat,	\
		$(BEATs),	\
		make docker.debian -B BEAT=$(beat); \
		make docker.static -B BEAT=$(beat) ; \
	)

clean: checkout.reset
	rm -rf out
	rm -f *.Dockerfile.distroless

checkout.reset:
	cd beats && git checkout . && git checkout master && cd -

# .PHONY: checkout.version
checkout.version: checkout.reset
	git submodule update --init --recursive &&  \
	cd beats && git checkout master && git pull && git checkout v$(VERSION) && cd -
	
