SHELL := /bin/bash

TRAVIS_BUILD_ID ?= 1
TRAVIS_COMMIT ?= c5df516bd309e1c3a44b8eab78a2b1bd0476372f

# Binaries prerequisites (should include `kubectl` once the cluster is known)
BIN_IMAGE ?= travis-poc-tools:1
BIN = docker run --rm -v $(PWD)/infra:/infra ${BIN_IMAGE}
KUBECTL = kubectl --context=docker-desktop -n technical-test

MANIFEST_PATH = ./infra/manifest.yaml

.PHONY: build-dev
build-dev:
	@echo Building docker image for local development and testing
	docker build --build-arg COMMIT_SHA='${TRAVIS_COMMIT}' -f ./Dockerfile-test -t travis-poc:${TRAVIS_BUILD_ID}-dev .

.PHONY: build-release
build-release:
	@echo Building docker image for production
	docker build --build-arg COMMIT_SHA='${TRAVIS_COMMIT}' -t travis-poc:${TRAVIS_BUILD_ID} .

.PHONY: test
test: build-dev
	@echo Running containerized tests
	docker run --user 1001 -p 8080:8080 --rm travis-poc:${TRAVIS_BUILD_ID}-dev npm run test

# ----
#
# Targets for working locally
#
# ----

.PHONY: run-local
run-local: build-dev
	docker run --user 1001 -p 8080:8080 --rm travis-poc:${TRAVIS_BUILD_ID}-dev

.PHONY: debug-local
debug-local: build-dev
	docker run --user 1001 -p 8080:8080 -it travis-poc:${TRAVIS_BUILD_ID}-dev bash

# ----
#
# Deploy to Docker desktop kubernetes
#
# ----

.PHONY: build-bin
build-bin:
	@echo Building bin image
	#docker image inspect $(BIN_IMAGE) >/dev/null 2>&1
	docker build -t ${BIN_IMAGE} ./toolset

.PHONY: kustomize
kustomize: build-bin
	@echo Building kubernetes manifest with kustomize
	${BIN} kustomize build /infra/overlays/production/ > ${MANIFEST_PATH}

.PHONY: apply
apply:
	@echo Applying manifest to docker-desktop cluster
	${KUBECTL} apply -f ${MANIFEST_PATH}

.PHONY: deploy
deploy: build-bin kustomize apply

.PHONY: uninstall-k8s-resources
uninstall-k8s-resources:
	@echo Removing all deployed resources from k8s cluster
	${KUBECTL} delete all -l app=version-service

.PHONY: clean
clean:
	@rm ${MANIFEST_PATH}
