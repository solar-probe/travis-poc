FROM alpine:3.10
WORKDIR /usr/bin
ARG KUSTOMIZE_VERSION=3.1.0
RUN apk --no-cache add curl

RUN curl -L -O https://github.com/kubernetes-sigs/kustomize/releases/download/v${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_linux_amd64 > kustomize \
  && mv kustomize_${KUSTOMIZE_VERSION}_linux_amd64 kustomize \
  && chmod +x kustomize

RUN kustomize version
CMD [ "/bin/bash" ]
