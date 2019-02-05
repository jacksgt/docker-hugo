FROM golang:1.11 AS builder

ARG HUGO_BUILD_TAGS="extended"
ARG VERSION="v0.54.0"

RUN go get github.com/magefile/mage && \
    go get -d github.com/gohugoio/hugo && \
    cd ${GOPATH}/src/github.com/gohugoio/hugo && \
    git checkout "$VERSION" && \
    mage hugo && \
    mage install

FROM scratch

COPY --from=builder /go/bin/hugo /bin/hugo

WORKDIR /opt/blog

VOLUME /opt/blog
