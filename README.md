# CI/CD with Travis [![Build Status](https://travis-ci.com/solar-probe/travis-poc.svg?branch=master)](https://travis-ci.com/solar-probe/travis-poc)

## Run locally

To start the app:
```bash
$ make build-dev
$ make run-local
```
It is possible to pass custom build id which will be used as image tag: `TRAVIS_BUILD_ID=my-cutom-id make build-dev`

After the app started successfully you can access it on port 8080:
```bash
curl http://localhost:8080/version
```
