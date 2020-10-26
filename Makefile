BEAT ?= filebeat
VERSION := $(shell cat .version)
DISTROLESS ?= static
BEATs ?= $(shell ls beats/ |grep beat)

build: checkout.version
	bash -x buildx.sh

docker.prepare:
	rm -f $(BEAT).Dockerfile.distroless && \
	cp -a Dockerfile.distroless.tpl $(BEAT).Dockerfile.distroless && \
	sed -i "s/{{ BEAT_BIN }}/$(BEAT)/g" $(BEAT).Dockerfile.distroless

docker.distroless: docker.prepare
	docker buildx build --push --platform=linux/amd64,linux/arm64 --progress plain \
		--tag tangx/$(BEAT):$(VERSION)-$(subst :,-,$(DISTROLESS)) \
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
docker.all:
	# $(foreach beat,$(BEATs),make docker.static -B BEAT=$(beat))
	$(foreach beat,	\
		$(BEATs),	\
		make docker.static -B BEAT=$(beat) ;	\
	)

clean: checkout.reset
	rm -rf out

checkout.reset:
	cd beats && git checkout . && git checkout master

checkout.version:
	git submodule update --init --recursive && \
		cd beats && git checkout v$(VERSION) 