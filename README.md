# CI/CD with Travis and Kubernetes Deploy [![Build Status](https://api.travis-ci.org/solar-probe/travis-poc.svg?branch=master)](https://travis-ci.com/solar-probe/travis-poc)

Although this project implements both tests, please review Test 2 (test 1 is incomplete)

## Run locally (containerized)

To start the app:
```bash
$ make build-dev
$ make run-local
```
It is possible to pass custom build number and/or commit sha: `TRAVIS_BUILD_NUMBER=1234 TRAVIS_COMMIT_SHA='c5df516bd309e1c3a44b8eab78a2b1bd0476372f' make build-dev`
Note that the same values have to be passed to both commands to work properly.

After the app started successfully you can access it on port 8080:
```bash
$ curl http://localhost:8080/version
$ {"myapplication":[{"version":"1.0","lastcommitsha":"c5df516bd309e1c3a44b8eab78a2b1bd0476372f","description":"https://www.nasa.gov/content/goddard/parker-solar-probe-videos"}]}
```
If image is built in Travis, the commit sha from `TRAVIS_COMMIT` will be used and passed to the container. When running locally it is the value provided in local env, or hardcoded default will be used

## Deploy to local cluster

Build image with default tag and deploy to local Docker Desktop kubernetes

```bash
$ make deploy
```

This command builds image locally, creates kubernetes manifests using containerized `kustomize` tool, and applies it to kubernetes cluster `technical-interview` namespace using local `kubectl`
Because it is not known the cluster configuration where this app will be deployed, configuring `kubectl` is out of scope

### Some Limitations
- Currently the default tag is hardcoded in `infra/overlays/production/kustomization.yaml`, however this file is a very small set of overrides that actually makes the deployment config dynamic.
- There is some redundancy in building images in some Makefile commands, even if they are locally built quickly thanks to cache. I had to do it this way to make CI working. As I am not familiar with Travis CI it takes more time to set up artifacts/caches properly
